""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSCOPE settings for vim           
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim... 
if has("cscope")

	""""""""""""" Standard cscope/vim boilerplate

	" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
	set cscopetag

	" check cscope for definition of a symbol before checking ctags: set to 1
	" if you want the reverse search order.
	set csto=0

	" Drew customization: run a script "cscope.build" if it exists
	" in order to update the list of files to be scanned, stored in
	" cscope.files
	if filereadable("./cscope.vim")
		:!./cscope.build
	endif
	if filereadable("~/src/cscope.out")
		:!cs add ~src/cscope.out
	endif
	
	" add any cscope databases we can find (Hacked by Drew)
	set nocscopeverbose
	cs add cscope.out  
	cs add ~/src/cscope.out  
	set cscopeverbose  

	" use the quickfix window for cscope stuff
	"set cscopequickfix=s-,c-,d-,i-,t-,e-

	""""""""""""" My cscope/vim key mappings
	"
	" The following maps all invoke one of the following cscope search types:
	"
	"   's'   symbol: find all references to the token under cursor 
	"   'g'   global: find global definition(s) of the token under cursor 
	"   'c'   calls:  find all calls to the function name under cursor 
	"   't'   text:   find all instances of the text under cursor 
	"   'e'   egrep:  egrep search for the word under cursor
	"   'f'   file:   open the filename under cursor 
	"   'i'   includes: find files that include the filename under cursor 
	"   'd'   called: find functions that function under cursor calls
	"


	" You can use CTRL-T to go back to where you were before the search.  
	nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
	nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
	nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
	nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
	nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
	nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
	nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	

	" split vim window horizontally, with search result displayed in
	" the new window.

	if has("gui_running")
		nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
		nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
		nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
		nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
		nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
		nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
		nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
		nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>	
		nmap <C-Space>r :!cscope -Rb <CR><CR>:cs kill 0<CR>:cs add ~/src/cscope.out<CR>
	else
		nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
		nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
		nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
		nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
		nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
		nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
		nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
		nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>	
		nmap <C-@>r :!cscope -Rb <CR><CR>:cs kill 0<CR>:cs add ~src/cscope.out<CR>
	endif

endif


