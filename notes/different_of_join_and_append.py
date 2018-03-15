# append
# append is a function of LIST，it can be any element that be appended at the end of a list
# a=[1,2,3]
# a.append(4)
# a = [1,2,3,4]

a = [1,2,3]
print (a)
a.append(4)
print (a)

# join
# join是string（字符串）的方法，函数参数是一个由字符串组成的列表比如['a','b','c']，作用是用字符串把这个字符串列表里的字符串连接起来，比如：
# a='-'
# 则a.join(['a','b','c'])='a-b-c'

a = ["hello","world","!"]

#用' '隔开
b = ' '
print (b.join(a))

#用':'隔开
print (':'.join(a))
