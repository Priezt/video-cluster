#!ruby
# encoding=UTF-8

require 'tk'
require './conf'

class Cluster
	def file_count(c)
		(Dir.glob $FILEDIR + "/*.*").sort.select do |f|
			f =~ $CATEGORY_HASH[c]
		end.length
	end

	def initialize
		@cur_cate = nil
	end

	def category
		@cur_cate
	end

	def all
		$CATEGORY_HASH.keys.sort.select do |c|
			file_count(c) > 0
		end
	end

	def select_idx(idx)
		select all[idx]
	end

	def select(c)
		@cur_cate = c
	end

	def select_file(f)
		f_escaped = f.gsub("/", "\\")
		puts f_escaped
		system("start " + f_escaped.encode("GB2312")) # system use GB2312
		exit
	end

	def clear_selection
		@cur_cate = nil
	end

	def files
		if @cur_cate then
			(Dir.glob $FILEDIR + "/*.*").sort.select do |f|
				f =~ $CATEGORY_HASH[@cur_cate]
			end
		else
			[]
		end
	end

	def selected?
		if @cur_cate then
			true
		else
			false
		end
	end
end

$cluster = Cluster.new

$root = TkRoot.new
$root.title = 'Video Cluster'

$file_list = TkListbox.new($root) do
	width 80
	height 20
	pack 'fill' => 'both'
	$cluster.clear_selection
	clear
	insert 0, *($cluster.all)
end

def select_in_list
	return if $file_list.curselection.length == 0
	idx = $file_list.curselection[0]
	#puts "idx: " + idx.to_s
	if $cluster.selected? then
		puts "select file"
		$cluster.select_file $cluster.files[$file_list.curselection[0]]
	else
		#puts "select category"
		$cluster.select_idx idx
		puts "select: " + $cluster.category
		$file_list.clear
		$file_list.insert 0, *($cluster.files)
		puts $cluster.files.length
	end
end

TkButton.new($root) do
	text "Open"
	width 20
	pack("side" => "left")
	command(proc {
		select_in_list
	})
end

TkButton.new($root) do
	text "Back"
	width 20
	pack("side" => "right")
	command(proc {
		$cluster.clear_selection
		$file_list.clear
		$file_list.insert 0, *($cluster.all)
	})
end

Tk.mainloop

