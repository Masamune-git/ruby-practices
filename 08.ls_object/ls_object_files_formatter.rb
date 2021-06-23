# frozen_string_literal: true

module Ls
  class FilesFormatter
    COLUMNVAL = 3

    def initialize(file_entries)
      @file_entries = file_entries.map { |file| FileFormatter.new(file) }
    end

    def blocks_sum
      @file_entries.map(&:blocks).sum
    end

    def links_max_length
      @file_entries.map(&:link).max_by(&:length).size + 1
    end

    def users_max_length
      @file_entries.map(&:user).max_by(&:length).size
    end

    def groups_max_length
      @file_entries.map(&:group).max_by(&:length).size
    end

    def file_sizes_max_length
      @file_entries.map(&:file_size).max_by(&:length).size + 2
    end

    def max_filename_length
      @file_entries.map(&:path).max_by(&:length).size + 1
    end

    def file_times_max_length
      @file_entries.map(&:time).max_by(&:length).size
    end

    def file_entries_transpose
      @file_entries << FileFormatter.new('') while @file_entries.size % COLUMNVAL != 0
      @file_entries.each_slice(@file_entries.size / COLUMNVAL).to_a.transpose
    end

    def file_path_format(file_status)
      file_status.path.to_s.ljust(max_filename_length)
    end

    def permission_format(file_status)
      file_status.permission.to_s.ljust(11)
    end

    def link_format(file_status)
      file_status.link.to_s.rjust(links_max_length)
    end

    def user_format(file_status)
      " #{file_status.user.ljust(users_max_length)}"
    end

    def group_format(file_status)
      "  #{file_status.group.ljust(groups_max_length)}"
    end

    def file_size_format(file_status)
      file_status.file_size.rjust(file_sizes_max_length).to_s
    end

    def time_format(file_status)
      "  #{file_status.time.rjust(file_times_max_length)} "
    end

    def default
      output_formats = []
      file_entries_transpose.size.times do |array_num|
        file_entries_transpose[array_num].each do |file|
          output_formats << file_path_format(file)
        end
        output_formats << "\n"
      end
      Output.new(output_formats.join).output
    end

    def longformat
      output_formats = []
      output_formats << "total #{blocks_sum}\n"
      output_formats << @file_entries.map do |file|
        "#{permission_format(file)}"\
       "#{link_format(file)}"\
       "#{user_format(file)}"\
       "#{group_format(file)}"\
       "#{file_size_format(file)}"\
       "#{time_format(file)}"\
       "#{file_path_format(file)}"\
       "\n"
      end
      Output.new(output_formats.join).output
    end
  end
end
