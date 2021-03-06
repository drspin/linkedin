module LinkedIn
  module Api
    module PostMethods
      #
      # group_posts(options={})
      #
      # inputs: 
      #   REQUIRED
      #     :group_id - the numeric id of the group to pull posts from.
      #   OPTIONAL
      #     :count - number of posts to retun (max 50)
      #     :start - post number to start pulling from
      #
      # outputs:
      #   Mash of json results from LinkedIn service
      #
      # description: Retreive posts from a given group and filter
      #              based on optional inputs.
      #
      def group_posts(options={})
        options.reverse_merge!({:order => "recency"})
        if options[:group_id]
          group_id = options.delete(:group_id)
        else
          raise ":group_id option required for group_posts method"
        end
        path = "/groups/#{group_id}/posts:(title,summary,creator,id)"
        simple_query(path, options)
      end

    end # PostMethods
  end # Api
end # LinkedIn
