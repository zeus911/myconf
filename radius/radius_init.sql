 use radius;
 #-------------------------------------------------
# 加入组信息，本例中的组名为user
 insert into radgroupreply (groupname,attribute,op,value) values ('vpn_grp','Auth-Type',':=','Local');
 insert into radgroupreply (groupname,attribute,op,value) values ('vpn_grp','Service-Type','=','Framed-User');
 insert into radgroupreply (groupname,attribute,op,value) values ('vpn_grp','Framed-IP-Netmask',':=','255.255.255.0');
# 加入用户信息
 INSERT INTO radcheck (UserName, Attribute, Value) VALUES ('vpn', 'Password', 'themass');
# 用户加到组里
 insert into radusergroup(username,groupname) values('vpn','vpn_grp');
# 限制账户同时登陆次数
 INSERT INTO radgroupcheck (GroupName, Attribute, op, Value) values('vpn_grp', 'Simultaneous-Use', ':=', '1');
#在数据库中限制用户组的最大流量为1M(本例中的用户组名为user)
 INSERT INTO radgroupcheck (GroupName,attribute,op,Value) VALUES ('vpn_grp','Max-Monthly-Traffic',':=','1048576');
  # 流量统计时间的间隔（60秒）
 INSERT INTO radgroupcheck (GroupName,attribute,op,Value) VALUES ('vpn_grp','Acct-Interim-Interval',':=','60');
 # 加入一个新的VPN用户（用户名zhukun.net，密码abc123）
 INSERT INTO radcheck (UserName, Attribute, Value) VALUES ('123', 'Password', '123456');
 #将用户zhukun.net加到组里
 insert into radusergroup(username,groupname) values('123','vpn_grp');
#------------------------------------QQ------------------------------------
 insert into radgroupreply (groupname,attribute,op,Value) values ('VPN_QQ','Auth-Type',':=','Local');
 insert into radgroupreply (groupname,attribute,op,Value) values ('VPN_QQ','Service-Type','=','Framed-User');
 insert into radgroupreply (groupname,attribute,op,Value) values ('VPN_QQ','Framed-IP-Netmask',':=','255.255.255.0');
 
# 限制账户同时登陆次数800人
 INSERT INTO radgroupcheck (GroupName, Attribute, op, Value) values('VPN_QQ', 'Simultaneous-Use', ':=', '800');
#在数据库中限制用户组的最大流量为500*3M/天(本例中的用户组名为user)
 INSERT INTO radgroupcheck (GroupName,attribute,op,Value) VALUES ('VPN_QQ','Max-Dayly-Traffic',':=','1024');
# 流量统计时间的间隔（60秒）
 INSERT INTO radgroupcheck (GroupName,attribute,op,Value) VALUES ('VPN_QQ','Acct-Interim-Interval',':=','60');
 
 INSERT INTO radcheck (UserName, Attribute,op, Value) VALUES ('free_lunch_qq', 'Cleartext-Password', ':=','justfun_apeng');
 INSERT INTO radusergroup(username,groupname) values('free_lunch_qq','VPN_QQ');
  
#------------------------------------super------------------------------------
 
 # 加入组信息，本例中的组名为user
 insert into radgroupreply (groupname,attribute,op,Value) values ('VPN_SUPER','Auth-Type',':=','Local');
 insert into radgroupreply (groupname,attribute,op,Value) values ('VPN_SUPER','Service-Type','=','Framed-User');
 insert into radgroupreply (groupname,attribute,op,Value) values ('VPN_SUPER','Framed-IP-Netmask',':=','255.255.255.0');
# 流量统计时间的间隔（60秒）
 INSERT INTO radgroupcheck (GroupName,attribute,op,Value) VALUES ('VPN_SUPER','Acct-Interim-Interval',':=','60');
 INSERT INTO radcheck (UserName, Attribute,op, Value) VALUES ('themass', 'Cleartext-Password', ':=','themass123');
 INSERT INTO radusergroup(username,groupname) values('themass','VPN_SUPER');
 
 #------------------------------------free no login------------------------------------
 # 加入组信息，本例中的组名为user
 insert into radgroupreply (groupname,attribute,op,Value) values ('VPN_FREE','Auth-Type',':=','Local');
 insert into radgroupreply (groupname,attribute,op,Value) values ('VPN_FREE','Service-Type','=','Framed-User');
 insert into radgroupreply (groupname,attribute,op,Value) values ('VPN_FREE','Framed-IP-Netmask',':=','255.255.255.0');
 
# 限制账户同时登陆次数800人
 INSERT INTO radgroupcheck (GroupName, Attribute, op, Value) values('VPN_FREE', 'Simultaneous-Use', ':=', '1');
#在数据库中限制用户组的最大流量为500*3M/天(本例中的用户组名为user)
 INSERT INTO radgroupcheck (GroupName,attribute,op,Value) VALUES ('VPN_FREE','Max-Dayly-Traffic',':=','100');
 INSERT INTO radgroupcheck (GroupName,attribute,op,Value) VALUES ('VPN_FREE','Max-Monthly-Traffic',':=','2048');
# 流量统计时间的间隔（60秒）
 INSERT INTO radgroupcheck (GroupName,attribute,op,Value) VALUES ('VPN_FREE','Acct-Interim-Interval',':=','60');

