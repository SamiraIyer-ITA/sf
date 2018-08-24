public class redirect_controller {

public string redirect {get; set;}
public redirect_controller(){
    this.redirect = ApexPages.CurrentPage().getParameters().get('dest');
}

}