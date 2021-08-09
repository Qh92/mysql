# 一、对比 # 　　
1、utf8_general_ci 不区分大小写， utf8_general_cs 区分大小写 　　
2、utf8_bin: compare strings by the binary value of each character in the string 将字符串每个字符串用二进制数据编译存储，区分大小写，而且可以存二进制的内容。 　　
3、utf8_unicode_ci校对规则仅部分支持Unicode校对规则算法,一些字符还是不能支持；utf8_unicode_ci不能完全支持组合的记号。 　　
说明：ci是 case insensitive, 即 "大小写不敏感", a 和 A 会在字符判断中会被当做一样的。bin 是二进制, a 和 A 会别区别对待。例如你运行:SELECT * FROM table WHERE txt = 'a'，那么在utf8_bin中你就找不到 txt = 'A' 的那一行, 而 utf8_general_ci 则可以。utf8_general_ci是一个遗留的 校对规则，不支持扩展，它仅能够在字符之间进行逐个比较。这意味着utf8_general_ci校对规则进行的比较速度很快，但是与使用 utf8_unicode_ci的校对规则相比，比较正确性较差。 

# 二、应用上的差别 　 #　
1、对于一种语言仅当使用utf8_unicode_ci排序做的不好时，才执行与具体语言相关的utf8字符集校对规则。例如，对于德语和法语，utf8_unicode_ci工作的很好，因此不再需要为这两种语言创建特殊的utf8校对规则。 　　
2、utf8_general_ci也适用与德语和法语，除了‘?’等于‘s’，而不是‘ss’之外。如果你的应用能够接受这些，那么应该使用 utf8_general_ci，因为它速度快。否则，使用utf8_unicode_ci，因为它比较准确。 

# 三、使用 # 　　
utf8_unicode_ci比较准确，utf8_general_ci速度比较快。通常情况下，新建数据库时一般选用utf8_general_ci就可以了。