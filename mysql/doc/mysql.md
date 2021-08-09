 本文档讲解安装版本为mysql-8.0.19，对于其他版本，可能不适用此说明文档，请务必注意您的Mysql版本。

 安装过程中务必保证文件路径的前后统一，否则可能会导致不可预期的结果，推荐直接使用文中的命令进行操作。



使用命令 # service mysqld status 或者 # service mysql status 命令来查看mysql 的启动状态
如果是 mysqld is stopped 那就说明mysql服务是停止状态，
如果是 mysqld is running 那就说明mysql服务是启动状态

linux进入mysql

格式： mysql -h主机地址 -u用户名－p用户密码

1、例1：连接到本机上的MYSQL

一般可以直接键入命令

mysql -uroot -p
1
回车后提示你输密码，如果刚安装好MYSQL，超级用户root是没有密码的，故直接回车即可进入到MYSQL中了，MYSQL的提示符是：mysql>

2、连接到远程主机上的MySQL

假设远程主机的IP为：10.0.0.1，用户名为root,密码为123。则键入以下命令：

mysql -h10.0.0.1 -uroot -p123
1
（注：u与root可以不用加空格，其它也一样）

3、退出MySQL命令

exit （回车）


**一 安装前准备**
1、检查是否已经安装过mysql，执行命令

[root@localhost /]# rpm -qa | grep mysql

从执行结果，可以看出我们已经安装了mysql-libs-5.1.73-5.el6_6.x86_64，执行删除命令

[root@localhost /]# rpm -e --nodeps mysql-libs-5.1.73-5.el6_6.x86_64
再次执行查询命令，查看是否删除

[root@localhost /]# rpm -qa | grep mysql

2、查询所有Mysql对应的文件夹

[root@localhost /]# whereis mysql
mysql: /usr/bin/mysql /usr/include/mysql
[root@localhost lib]# find / -name mysql
/data/mysql
/data/mysql/mysql
删除相关目录或文件

[root@localhost /]#  rm -rf /usr/bin/mysql /usr/include/mysql /data/mysql /data/mysql/mysql 
验证是否删除完毕

[root@localhost /]# whereis mysql
mysql:
[root@localhost /]# find / -name mysql
[root@localhost /]# 
3、检查mysql用户组和用户是否存在，如果没有，则创建

[root@localhost /]# cat /etc/group | grep mysql
[root@localhost /]# cat /etc/passwd |grep mysql
[root@localhost /]# groupadd mysql
[root@localhost /]# useradd -r -g mysql mysql
[root@localhost /]# 
4、从官网下载是用于Linux的Mysql安装包

下载命令：

[root@localhost /]#  wget https://cdn.mysql.com/archives/mysql-8.0/mysql-8.0.19-linux-glibc2.12-x86_64.tar.xz
也可以直接到 mysql官网 选择对应版本进行下载。


**二 安装Mysql**
1、在执行wget命令的目录下或你的上传目录下找到Mysql安装包：mysql-8.0.19-linux-glibc2.12-x86_64.tar.xz
执行解压命令：

[root@localhost /]#  tar xvf mysql-8.0.19-linux-glibc2.12-x86_64.tar.xz
[root@localhost /]# ls
mysql-8.0.19-linux-glibc2.12-x86_64
mysql-8.0.19-linux-glibc2.12-x86_64.tar.xz
解压完成后，可以看到当前目录下多了一个解压文件，移动该文件到/usr/local/下，并将文件夹名称修改为mysql。

如果/usr/local/下已经存在mysql，请将已存在mysql文件修改为其他名称，否则后续步骤可能无法正确进行。

执行命令如下：

[root@localhost /]# mv mysql-8.0.19-linux-glibc2.12-x86_64 /usr/local/
[root@localhost /]# cd /usr/local/
[root@localhost /]# mv mysql-8.0.19-linux-glibc2.12-x86_64 mysql
如果/usr/local/下不存在mysql文件夹，直接执行如下命令，也可达到上述效果。

[root@localhost /]# mv mysql-8.0.19-linux-glibc2.12-x86_64 /usr/local/mysql
2、在/usr/local/mysql目录下创建data目录

[root@localhost /]# mkdir /usr/local/mysql/data
3、更改mysql目录下所有的目录及文件夹所属的用户组和用户，以及权限
先增加用户与用户组，创建用户的同时会默认创建相同名称的用户组

增加linux用户 adduser mysql

[root@localhost /]# chown -R mysql:mysql /usr/local/mysql
[root@localhost /]# chmod -R 755 /usr/local/mysql
4、编译安装并初始化mysql,务必记住初始化输出日志末尾的密码（数据库管理员临时密码）

[root@localhost /]# cd /usr/local/mysql/bin
[root@localhost bin]# ./mysqld --initialize --user=mysql --datadir=/usr/local/mysql/data --basedir=/usr/local/mysql
补充说明1：
mysql8.0.14以后版本，如果在my.cnf中配置lower-case-table-names=1以实现不区分表名大小写 ，启动数据库时将会报错，根据官方文档记录，只有在初始化时配置才有效，因此在初始化参数后添加参数 --lower-case-table-names=1

补充说明2：
第4步时，可能会出现错误：

![image-20210801221154777](assets\image-20210801221154777.png)


出现该问题首先检查该链接库文件有没有安装使用 命令进行核查

[root@localhost bin]# rpm -qa|grep libaio   
[root@localhost bin]# 
运行命令后发现系统中无该链接库文件

[root@localhost bin]#  yum -y install libaio-devel.x86_64
安装成功后，继续运行数据库的初始化命令，此时可能会出现如下错误：


执行如下命令后：

[root@localhost bin]#  yum -y install numactl
执行无误之后，再重新执行第4步初始化命令，无误之后再进行第5步操作！

5、运行初始化命令成功后，输出日志如下：


记录日志最末尾位置 root@localhost:后的字符串，此字符串为mysql管理员临时登录密码。

6、先不用配置该配置文件，编辑配置文件my.cnf，添加配置如下

[root@localhost bin]#  vi /etc/my.cnf

[mysqld]
datadir=/usr/local/mysql/data
port=3306
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
symbolic-links=0
max_connections=600
innodb_file_per_table=1
log-error=/usr/local/mysql/data/error.log
7、测试启动mysql服务器

[root@localhost /]# /usr/local/mysql/support-files/mysql.server start
显示如下结果，说明数据库安装并可以正常启动

异常情况

sh /usr/local/mysql/mysql-8.0.26/support-files/mysql.server start

上面启动mysql服务命令是会报错的，因为没有修改mysql的配置文件，报错内容大致如下：

./support-files/mysql.server: line 239: my_print_defaults: command not found

./support-files/mysql.server: line 259: cd: /usr/local/mysql: no such file or directory

starting mysql error! couldn't find mysql server (/usr/local/mysql/bin/mysqld_safe)


![image-20210801222242086](assets\image-20210801222242086.png)

解决方法：修改mysql配置文件

#vim /software/mysql/support-files/mysql.server

修改后

![image-20210801223901279](assets\image-20210801223901279.png)

保存退出

再启动mysql

如果出现如下提示信息

ERROR! The server quit without updating PID file (/usr/local/mysql/data/localhost.localdomain.pid).

查看错误日志 /usr/local/mysql/data/error.log

查看MySQL官方文档，有记录：
lower_case_table_names can only be configured when initializing the server. Changing the lower_case_table_names setting after the server is initialized is prohibited.
只有在初始化的时候设置 lower_case_table_names=1才有效
因此，我们此时需要删除 my.cnf中的lower_case_table_names=1的配置。
删除后，再次执行执行启动mysql命令：
/usr/local/mysql/support-files/mysql.server start

如果有其他异常，请进入 /usr/local/mysql/data/error.log 错误日志文件进行查看！

8、添加软连接，并重启mysql服务

[root@localhost /]#  ln -s /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql 
[root@localhost /]#  ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
[root@localhost /]#  service mysql restart

9、登录mysql，修改密码(密码为步骤5生成的临时密码)

[root@localhost /]#  mysql -u root -p
Enter password:
mysql>ALTER USER USER() IDENTIFIED BY 'mysql';
mysql>flush privileges;

10、开放远程连接

mysql>use mysql;
msyql>update user set user.Host='%' where user.User='root';
mysql>flush privileges;

通过可视化连接工具，测试远程连接。
注意远程连接时，需要开放远程服务器的连接端口，此处mysql服务开启端口为3306


11、设置开机自动启动

1、将服务文件拷贝到init.d下，并重命名为mysql
[root@localhost /]# cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
2、赋予可执行权限
[root@localhost /]# chmod +x /etc/init.d/mysqld
3、添加服务
[root@localhost /]# chkconfig --add mysqld
4、显示服务列表
[root@localhost /]# chkconfig --list

至此，Mysql-8.0.19版本的安装，已经全部完成。



linux安装MySQL报 error while loading shared libraries: libtinfo.so.5 解决办法

MySQL 我采用的是 Linux- Generic 包安装，其中详细略过不表。一顿操作之后，终于到将 mysql 服务启动。但是到了连接服务的时候却报错了。

mysql: error while loading shared libraries: libtinfo.so.5: cannot open shared object file: No such file or directory

解决办法：
sudo ln -s /usr/lib64/libtinfo.so.6.1 /usr/lib64/libtinfo.so.5


在安装完MySQL的时候，我们现在一般都使用Navicat来连接数据库，可惜出现下面的错误：1251-Client does not support authentication protocol requested by server; consider upgrading MySQL client。

出现上述问题的原因是：mysql8 之前的版本中加密规则是mysql_native_password,而在mysql8之后,加密规则是caching_sha2_password 把mysql用户登录密码加密规则还原成mysql_native_password

我安装的时候是使用的安装包去安装的，所以新建了几个用户，cmd命令，连接mysql，查询系统当中所有的用户。

1.查看MYSQL数据库中所有用户

mysql> SELECT DISTINCT CONCAT('User: ''',user,'''@''',host,''';') AS query FROM mysql.user;
2.修改加密规则，因为最新版的加密规则好像不一样，安装的过程当中是有提示的。

mysql> ALTER USER ‘root’@’localhost’ IDENTIFIED BY ‘password’ PASSWORD EXPIRE NEVER;
3.修改用户的认证规则

mysql> alter user '用户名'@'%' identified with mysql_native_password by '密码';
例如我的用户名是admin,密码是123456，那么，我修改的规则如下

mysql> alter user 'admin'@'%' identified with mysql_native_password by '123456';
其中还有'用户名'@'%'和'用户名'@'localhost'的区别，一个是任意连接，一个是本地连接。

4.刷新权限

mysql> flush privileges;
5.停止并重启服务

mysql> net stop mysql
mysql> net start mysql
这里需要注意的是：mysql这个是你的mysql服务的名称，具体名称如何查询呢？假如你的服务名称为MySQL80，那么mysql就得改成MySQL80。

现在再去用Navicat去连接数据库，就不会出现上述的问题了。