function data = in(filename="", stride=1, type="float32")
if ~exist(filename,"file"),
	filename = [filename ".dump"];
end
[fd,errmsg] = fopen(filename);
assert(fd!=-1,errmsg);

data = fread(fd, Inf, type);
fclose(fd);
if mod(length(data),stride),
	disp("Array length not multiple of stride; some likely options are:");
	p = factor(length(data));
	for i = 1:length(p)
		term1 = prod(p(1:i));
		term2 = prod(p(i+1:end));
		disp([num2str(term1) " x " num2str(term2)]);
	end
	exit
end
data = reshape(data, stride, length(data)/stride);
data = data';
if nargout==0,
	[dir, varname, ext, ver] = fileparts(filename);
	assignin("caller", varname, data);
end
