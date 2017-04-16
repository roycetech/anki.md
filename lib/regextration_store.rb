module RegextrationStore
  #
  class CommentBuilder
    RE_COMMENT_HTML = /&lt;!--.*--&gt;/
    RE_COMMENT_C = %r{\/\/.*|\/\*.*\*\/}
    RE_COMMENT_PERL = /#.*/
    RE_COMMENT_NONE = /(?!.*)/
    RE_COMMENT_SQL = /--.*/

    def initialize
      @regexp = nil
      @c      = nil
      @perl   = nil
      @html   = nil
      @sql    = nil
      @none   = nil
    end

    def none
      comment('@none', RE_COMMENT_NONE)
    end

    def c
      comment('@c', RE_COMMENT_C)
    end

    def perl
      comment('@perl', RE_COMMENT_PERL)
    end

    def html
      comment('@html', RE_COMMENT_HTML)
    end

    def sql
      comment('@sql', RE_COMMENT_SQL)
    end

    def build
      @regexp
    end

    private

      def comment(flag_name, regexp)
        unless instance_variable_get(flag_name)
          if @regexp
            @regexp += regexp
          else
            @regexp = regexp
          end
          instance_variable_set(flag_name, true)
        end
        self
      end
  end
end
