# frozen_string_literal: true

module Ls
  class Longformat
    def initialize(file_entries)
      @file_entries = file_entries
      blocks, permissions, links, users, groups, file_sizes, times, paths = Array.new(8).map { [] }
      convert_to_permission = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
      convert_to_filetype = { '00' => '-', '40' => 'd', '20' => 'l' }
      file_entries.each do |file|
        file_status = lstat(file)
        blocks << blocks(file_status)
        permissions << permissions(file_status, convert_to_filetype, convert_to_permission)
        links << links(file_status)
        users << users(file_status)
        groups << groups(file_status)
        file_sizes << file_sizes(file_status)
        times << times(file_status)
        paths << paths(file)
      end
      @longformats = { 'blocks' => blocks,
                       'permissions' => permissions,
                       'links' => links,
                       'users' => users,
                       'groups' => groups,
                       'file_sizes' => file_sizes,
                       'times' => times,
                       'paths' => paths }
    end

    def lstat(file)
      File.lstat("./#{file}")
    end

    def blocks_sum
      @file_entries.map { |file| lstat(file).blocks }.sum
    end

    def blocks(file_status)
      file_status.blocks
    end

    def permissions(file_status, convert_to_filetype, convert_to_permission)
      convert_to_filetype[file_status.mode.to_s(8)[-5, 2]] +
        convert_to_permission[file_status.mode.to_s(8)[-3, 1]] +
        convert_to_permission[file_status.mode.to_s(8)[-2, 1]] +
        convert_to_permission[file_status.mode.to_s(8)[-1, 1]]
    end

    def links(file_status)
      file_status.nlink.to_s
    end

    def users(file_status)
      Etc.getpwuid(file_status.uid).name.to_s
    end

    def groups(file_status)
      Etc.getgrgid(file_status.gid).name.to_s
    end

    def file_sizes(file_status)
      file_status.size.to_s
    end

    def times(file_status)
      "#{file_status.mtime.strftime('%m').to_i} #{file_status.mtime.strftime('%d')} #{file_status.mtime.strftime('%H:%M')}"
    end

    def paths(file_status)
      file_status
    end

    def output
      # puts "total #{@longformats['blocks'].map.sum}"
      puts "total #{blocks_sum}"
      @longformats['permissions'].size.times do |i|
        printf '% -*s', 11, (@longformats['permissions'][i]).to_s
        printf '% *s', @longformats['links'].max_by(&:length).size + 1, (@longformats['links'][i]).to_s
        printf '% -*s', @longformats['users'].max_by(&:length).size + 1, " #{@longformats['users'][i]}"
        printf '% -*s', @longformats['groups'].max_by(&:length).size + 2, "  #{@longformats['groups'][i]}"
        printf '% *s', @longformats['file_sizes'].max_by(&:length).size + 2, "  #{@longformats['file_sizes'][i]}"
        printf '%*s', 13, "#{@longformats['times'][i]} "
        puts format (@longformats['paths'][i]).to_s
      end
    end
  end
end
