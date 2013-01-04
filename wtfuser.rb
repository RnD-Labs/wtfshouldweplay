require 'rubberband'
require 'pp'
require 'steam-condenser'


class WTFUser

    def initialize(name)
        # Config should be from somewhere else
        @elastic = ElasticSearch::Client.new('127.0.0.1:9200', :index => 'test')
        @name = name
    end

    def fuck
        @elastic.search("custom_url:#{@name}", :type => 'user')
    end

    def games
        fetch_user
    end

    private
    # Fetch and/or populate the ES index for a user
    def fetch_user
        # Check if user is already in the index
##if @elastic.search("custom_url:#{@name}", :type => 'user').hits.empty?
            id = SteamId.new(@name)
            flist = ''
            id.friends.each do |f| 
                flist << f.steam_id64.to_s + "," 
            end
            glist = ''
            id.games.each do |g,k|
                glist << k.app_id.to_s + ","
            end
            
            @elastic.index({
                        :custom_url     => id.custom_url,
                        :nickname       => id.nickname,
                        :real_name      => id.real_name,
                        :friends        => flist,
                        :games          => glist,
                        :fetch_time     => id.fetch_time
                        }, :id => id.steam_id64, :type => 'user')
##        end
    end
end

a = WTFUser.new('guns5')
a.games
