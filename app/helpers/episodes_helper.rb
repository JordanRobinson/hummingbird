module EpisodesHelper
  # Get a list of four episodes from a list of a lot of episodes, trying its
  # best to ensure that the first has been watched by the user.
  #
  # Returns [[episode, watched?]].
  def select_four_episodes(watchlist, anime=nil)
    if watchlist
      @episodes = watchlist.anime.episodes.order(:number)
    else
      @episodes = anime.episodes.order(:number)
    end
    
    @episodes_watched = Hash.new(false)

    if watchlist
      watchlist.episodes.each do |episode|
        @episodes_watched[ episode.id ] = true
      end
    end
    
    # Figure out the range of 4 episodes to show.
    if @episodes_watched.keys.length == 0 or @episodes.length <= 4
      @episodes = @episodes[0..3]
    else
      latest_watched = watchlist.episodes.map(&:number).max
      if latest_watched+2 > @episodes.length-1
        @episodes = @episodes[-4..-1]
      else
        @episodes = @episodes[(latest_watched-1)..(latest_watched+2)]
      end
    end    
    return @episodes.map {|e| [e, @episodes_watched[e.id]] }
  end
end
