source /etc/profile 
catalina.sh version
shutdown.sh
startup.sh

cat<<EOL > /usr/local/tomcat9/conf/tomcat-users.xml
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <role rolename="tomcat"/>
  <role rolename="role1"/>
  <user username="zj" password="zj" roles="tomcat,role1,manager-gui,manager-script"/>
</tomcat-users>
EOL
echo "tomcat-users.xml 已更新。"

cat<<EOL > /usr/local/tomcat9/webapps/manager/META-INF/context.xml
<?xml version="1.0" encoding="UTF-8"?>
<Context antiResourceLocking="false" privileged="true" >
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict" />
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="\d+\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />

  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="^.*$" />
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\\\$LruCache(?:\\\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>
EOL
echo "context.xml 已更新。"

<?xml version="1.0" encoding="UTF-8"?>
<Context antiResourceLocking="false" privileged="true" >
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict" />
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="^.*$" />
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>

  <!-- Database Connection Pool Configuration -->
  <Resource name="jdbc/MyDB"
            auth="Container"
            type="javax.sql.DataSource"
            maxActive="100"
            maxIdle="30"
            maxWait="10000"
            username="root"
            password="zj123456"
            driverClassName="com.mysql.jdbc.Driver"
            url="jdbc:mysql://localhost:3306/pan"/>
</Context>


mkdir -p /usr/local/tomcat9/webapps/test/WEB-INF/{classes,lib}
cat<<EOL > /usr/local/tomcat9/webapps/test/index.jsp
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<html>
       <head>
              <title>test</title>
       </head>
       <body>
       <%
              out.println("Hello World!");
       %>   
       </body>
</html>
EOL
