module SolidCacheDashboard
  class CacheEntriesController < ApplicationController
    def index
      query = SolidCache::Entry.order(created_at: :desc)
      
      # Apply search filter if provided
      if params[:search].present?
        search_term = params[:search].strip
        
        # Convert search term to key hash for exact key_hash lookups
        require 'digest'
        key_hash = Digest::SHA256.digest(search_term).unpack("q>").first rescue nil
        
        # Search by key or key_hash
        query = query.where("key LIKE ? OR key_hash = ?", "%#{search_term}%", key_hash)
      end
      
      @pagy, entries = pagy(query, items: 25)
      @cache_entries = SolidCacheDashboard.decorate(entries)
    end

    def show
      @cache_entry = SolidCacheDashboard.decorate(
        SolidCache::Entry.find_by_key_hash(params[:id].to_i)
      )

      unless @cache_entry
        redirect_to cache_entries_path, alert: "Cache entry not found"
        return
      end
    end

    def delete
      cache_entry = SolidCache::Entry.find_by_key_hash(params[:id].to_i)

      if cache_entry
        cache_entry.delete
        redirect_to cache_entries_path, notice: "Cache entry deleted"
      else
        redirect_to cache_entries_path, alert: "Cache entry not found"
      end
    end

    def clear_all
      SolidCache::Entry.delete_all
      SolidCacheDashboard::CacheEvent.delete_all if defined?(SolidCacheDashboard::CacheEvent)
      redirect_to cache_entries_path, notice: "All cache entries and statistics have been reset"
    end
  end
end
