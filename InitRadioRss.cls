public class InitRadioRss{

    public static String url = 'https://ici.radio-canada.ca/rss/4159';
    @future(callout=true)
    public static void getRss() {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(InitRadioRss.url);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        
        Dom.Document doc = res.getBodyDocument();
                        
        Dom.XMLNode newsRss = doc.getRootElement();       
        Dom.XMLNode channel = newsRss.getChildElement('channel', null);
        Dom.XmlNode[] items = channel.getChildElements();
        
        for(Dom.XMLNode item: items) {
            if (item.getName() != 'item') {
                continue;
            }
        
            //DateTime.myDateTime = DateTime.newInstance(item.getChildElement('pubDate', null).getText());
            
            ICI_Rss__c[] news = new List<ICI_Rss__c>();
            ICI_Rss__c nouvelle = new ICI_Rss__c(
                Title__c = item.getChildElement('title', null).getText(),
                Link__c = item.getChildElement('link', null).getText(),
                Time__c = new GMT(item.getChildElement('pubDate', null).getText()).getDateTime()
            );
            
            news.add(nouvelle);
            upsert news Title__c;
        }
        
    }
    
    public class GMT {
    
        public Datetime dt;
                
        public GMT(String myDateTime) {
            String[] timeStrArr = myDateTime.split(' ');
            
            integer year = integer.valueOf(timeStrArr[3]);
            integer month = this.getMonth(timeStrArr[2]);
            integer day = integer.valueOf(timeStrArr[1]);
            
            String[] t = timeStrArr[4].split(':');
            integer h = integer.valueOf(t[0]);
            integer m = integer.valueOf(t[1]);
            integer s = integer.valueOf(t[2]);
            
            this.dt = Datetime.newInstance(year, month, day, h, m, s);
            
        }
        
        public Datetime getDateTime() {
            return this.dt;
        }
       
        private integer getMonth(String month) {
            String monNum;
        
            if(month.equals('Jan')) monNum = '1';
            if(month.equals('Feb')) monNum = '2';
            if(month.equals('Mar')) monNum = '3';
            if(month.equals('Apr')) monNum = '4';
            if(month.equals('May')) monNum = '5';
            if(month.equals('Jun')) monNum = '6';
            if(month.equals('Jul')) monNum = '7';
            if(month.equals('Aug')) monNum = '8';
            if(month.equals('Sep')) monNum = '9';
            if(month.equals('Oct')) monNum = '10';
            if(month.equals('Nov')) monNum = '11';
            if(month.equals('Dec')) monNum = '12';
            
            integer mon = integer.valueOf(monNum);
            return mon;
        
        }
    }
}