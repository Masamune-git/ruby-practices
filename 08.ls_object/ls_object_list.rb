# frozen_string_literal: true

module Ls
  class List
    def initialize(file_entries,option)
      file_entries = Dir.glob('*', File::FNM_DOTMATCH).sort if option.include?('a')
      file_entries = file_entries.reverse if option.include?('r')

      if option.include?('l')
        list_segments_output_longformat(file_entries)
      else
        list_segments_output(file_entries)
      end
    end

    def list_segments_output(file_entries)
      max_filename_length = file_entries.max_by(&:length).size + 2
      file_entries << '' while file_entries.size % 3 != 0
      file_entries_transpse = file_entries.each_slice(file_entries.size / 3).to_a.transpose
      file_entries_transpse.size.times do |x|
        file_entries_transpse[x].each  do |file|
          printf '% -*s', max_filename_length, file.to_s
        end
        print "\n"
      end
    end

    def list_segments_output_longformat(file_entries)
      long_format = Longformat.new(file_entries)
      # blocks, permissions, links, users, groups, file_sizes, times, paths = Array.new(8).map { [] }
      # convert_to_permission = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
      # convert_to_filetype = { '00' => '-', '40' => 'd', '20' => 'l' }
      # file_entries.each do |x|
      #   fs = File.lstat("./#{x}")
      #   blocks << fs.blocks
      #   permissions << convert_to_filetype[fs.mode.to_s(8)[-5, 2]] + convert_to_permission[fs.mode.to_s(8)[-3, 1]] + convert_to_permission[fs.mode.to_s(8)[-2, 1]] + convert_to_permission[fs.mode.to_s(8)[-1, 1]]
      #   links << fs.nlink.to_s
      #   users << Etc.getpwuid(fs.uid).name.to_s
      #   groups << Etc.getgrgid(fs.gid).name.to_s
      #   file_sizes << fs.size.to_s
      #   times << "#{fs.mtime.strftime('%m').to_i} #{fs.mtime.strftime('%d')} #{fs.mtime.strftime('%H:%M')}"
      #   paths << x
      # end
      # puts "total #{blocks.map.sum}"
      # longformats = { 'permissions' => permissions, 'links' => links, 'users' => users, 'groups' => groups, 'file_sizes' => file_sizes, 'times' => times,
      #                 'paths' => paths }
      # output(longformats)
    end

    # def output(longformats)
    #   longformats['permissions'].size.times do |i|
    #     printf '% -*s', 11, (longformats['permissions'][i]).to_s
    #     printf '% *s', longformats['links'].max_by(&:length).size + 1, (longformats['links'][i]).to_s
    #     printf '% -*s', longformats['users'].max_by(&:length).size + 1, " #{longformats['users'][i]}"
    #     printf '% -*s', longformats['groups'].max_by(&:length).size + 2, "  #{longformats['groups'][i]}"
    #     printf '% *s', longformats['file_sizes'].max_by(&:length).size + 2, "  #{longformats['file_sizes'][i]}"
    #     printf '%*s', 13, "#{longformats['times'][i]} "
    #     puts format (longformats['paths'][i]).to_s
    #   end
    # end

  end
end
