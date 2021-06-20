# idempiere for Openlayers 2
[ZK](https://github.com/zkoss/zk) wrapper for [OpenLayers 2](https://github.com/openlayers/openlayers), an industry
standard JS library for embedding interactive maps in web applications.

This project enables you to create Maps, Layers, and Features in Java or ZUL, with server side event handling and updates and run on iDempiere ERP whith Business Theme

## Download

#### Requirements
1. OpenJDK 11
2. Maven 3.0 or above
2. iDempiere 8.2.0 or above whith build tycho (http://wiki.idempiere.org/en/Building_iDempiere_by_tycho)

## Quick Start
1. Clone this repository
2. Build zkopenlayers for local repository: cd org.zkoss.zkopenlayers; mvn install
3. Rewrite pom and META-INFO in original Idempiere:
org.adempiere.ui.zk
org.idempiere.zk.extra 

Install this bundles or build full version iDempiere (maven and tycho: mvn verify)
On bundle org.idempiere.zk.extra --- info whith Openlayers

4. Build bundle business theme: cd ru.novaris.idempiere.ui.zk.themes; mvn verify  
5. Deploy theme bundle to iDempiere by OSGi console and change theme iDempiere to business (ZK_THEME - searchKey to "business") 
6. Example application in ru.novaris.idempiere.nms.ui.zk.openlayers (need change before deploy)  

## ZK Version
Applicable to iDempiere 8.2 and later.


##Project License
[GNU General Public License (GPL) v2](https://www.gnu.org/licenses/gpl-2.0.txt)

