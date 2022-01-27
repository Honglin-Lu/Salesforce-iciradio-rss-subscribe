public class RadioCanadaRss implements Schedulable {
        
    public void execute(SchedulableContext ctx) {
        
        InitRadioRss.getRss();
    }
    
    
}
