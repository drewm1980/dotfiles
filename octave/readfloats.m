function data = readfloats(filename, count)
if ~exist(filename,"file"),
	filename = [filename ".dump"];
end
[fd,errmsg] = fopen(filename);
assert(fd!=-1,errmsg);

data = fread(fd, count, "float32");
fclose(fd);
