# DELETE old Build plugins
rm build.plugins/*.jar

# Start jetty server for idempiere repository

mvn -f pom-jetty.xml jetty:run &


#  COMMAND TO Build Maven Plugins
#mvn verify -Didempiere.target=ru.novaris.idempiere.p2.targetplatform -X
mvn verify -Didempiere.target=ru.novaris.idempiere.p2.targetplatform

# COPY Build plugins to build.plugins directory
cp ru.novaris.idempiere.p2.site/target/repository/plugins/*.jar build.plugins/


# NOTE: Compilation is configured for local MAC OS development environment
# Compiling in a different server setup you need to change relativePath and Location.
#
# 1. Change Relative Path in files:
#   ru.novaris.idempiere.p2.site/pom.xml
#   ru.novaris.idempiere.p2.targetplatform/pom.xml
#  Relative Path is set as: 
#  <relativePath>../../idempiere/org.idempiere.parent/pom.xml</relativePath>
#
# 2. Change the repository location in file:
#   ru.novaris.idempiere.p2.targetplatform/ru.novaris.idempiere.p2.targetplatform.target
#   Repository Location is set as: 
# 		<repository location="file:///../idempiere/org.idempiere.p2/target/repository"/>
