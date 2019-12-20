public class CP_Redirect_Controller{
    public CP_Redirect_Controller(){
    }
    public pageReference redirectToPage(){
            PageReference pg = new PageReference(Label.CP_Redirect_URL);
            pg.setRedirect(true);
            return pg;
    }
}