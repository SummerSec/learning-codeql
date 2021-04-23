select sum(int i, int j |
    exists(string s | s = "hello".charAt(i)) 
    and exists(string s | s = "world!".charAt(j)) | i)


