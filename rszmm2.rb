require 'mini_magick'
 
maxSize=800;

File.open('tags.txt', 'w') {|file| file.truncate(0) }
 
class Img
 #@x,@y,@xnew,@ynew=0
 def initialize(file)
   @img=MiniMagick::Image.open(file)
   @file=file
   @x=@img.width
   @y=@img.height
   puts "Original width=#{@x}"
   puts "Original height=#{@y}"
 end
 
 def resizeImg(maxSize)
   #puts "maxSize=#{maxSize}"
   @maxSize=maxSize
   if @x>@y then
     @xnew=maxSize
	 @ynew=(maxSize.fdiv(@x))*@y.round(0)
   else
     @ynew=maxSize
	 @xnew=(maxSize.fdiv(@y))*@x.round(0)
   end;
   print "Processing #{@file}..."
   @img.resize "#{@xnew}x#{@ynew}"
   puts "done"
 end
 
 def saveImg(path)
   #puts "Save"
   fname=path+@file.gsub(".","_"+@maxSize.to_s+".")
   #puts fname
   @img.write "#{fname}"
   @fname=fname
 end
 
 def generateTag
   File.open('tags.txt','a') do |f|
     f.puts("{% img center /images/2016/#{@file.gsub(".","_"+@maxSize.to_s+".")} %}");
   end;
 end
end 

fsorted=[]
if ARGV[0]=='--last'
  then fsorted << Dir['*.jpg'].sort_by{|f| File.mtime(f)}.last
  #puts fsorted
elsif ARGV[0]=='--latest'
  then fsorted = Dir['*.jpg'].sort_by{|f| File.mtime(f)}.last(ARGV[1].to_i)
  #puts fsorted   
else fsorted = ARGV
  #puts fsorted 
end;
fsorted.each do |x|
 i=Img.new(x)
 i.resizeImg(maxSize);
 i.saveImg("c:\\Users\\Maxim\\Documents\\Octopress\\source\\images\\2016\\");
 i.generateTag;
end 
 