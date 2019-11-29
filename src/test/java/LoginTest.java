package com.PageActions;
import BaseTest.BaseTest;
import com.pageObjects.LoginPage;
import org.openqa.selenium.Keys;
import org.testng.annotations.Test;

public class LoginTest extends BaseTest {

    protected LoginPage loginPage;

    @Test
    public void login(){
        loginPage  =new LoginPage();
        loginPage.firstName.sendKeys("Ashlin");
        loginPage.lastName.sendKeys("Docker");
//        loginPage.password.sendKeys("Rmb@135");
//        loginPage.password.sendKeys(Keys.TAB);
        boolean found=loginPage.btnLogin.isDisplayed();
        System.out.println(found);

    }


}
