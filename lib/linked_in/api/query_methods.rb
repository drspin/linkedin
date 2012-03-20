module LinkedIn
  module Api

    module QueryMethods

      def profile(options={})
        path = person_path(options)
        simple_query(path, options)
      end

      def connections(options={})
        path = "#{person_path(options)}/connections"
        simple_query(path, options)
      end

      def network_updates(options={})
        path = "#{person_path(options)}/network/updates"
        simple_query(path, options)
      end

      def company(options = {})
        path   = company_path(options)
        simple_query(path, options)
      end

      def groups(options={})
        path = "#{person_path(options)}/group-memberships?membership-state=member"
        group_mash = simple_query(path, options)
        group_mash.all
      end

      def suggested_groups(options={})
        path   = "#{person_path(options)}/suggestions/groups"
        simple_query(path, options)
      end

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

      private

        def simple_query(path, options={})
          fields = options.delete(:fields) || LinkedIn.default_profile_fields

          if options.delete(:public)
            path +=":public"
          elsif fields
            path +=":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
          end
          
          headers = options.delete(:headers) || {}
          params  = options.map { |k,v| "#{k}=#{v}" }.join("&")
          path   += "?#{params}" if not params.empty?

          Mash.from_json(get(path, headers))
        end

        def person_path(options)
          path = "/people/"
          if id = options.delete(:id)
            path += "id=#{id}"
          elsif url = options.delete(:url)
            path += "url=#{CGI.escape(url)}"
          else
            path += "~"
          end
        end

        def company_path(options)
          path = "/companies/"
          if id = options.delete(:id)
            path += "id=#{id}"
          elsif url = options.delete(:url)
            path += "url=#{CGI.escape(url)}"
          elsif name = options.delete(:name)
            path += "universal-name=#{CGI.escape(name)}"
          elsif domain = options.delete(:domain)
            path += "email-domain=#{CGI.escape(domain)}"
          else
            path += "~"
          end
        end

    end

  end
end
