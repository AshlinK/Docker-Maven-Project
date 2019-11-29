package com.pageObjects;
import BaseTest.BaseTest;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;



public class LoginPage extends BaseTest {

    @FindBy(xpath="//input[@name='firstname']")
    public  WebElement firstName;

    @FindBy(xpath="//input[@name='firstname']")
    public  WebElement lastName;

    @FindBy(id="password")
    public  WebElement password;

    @FindBy(id="buttonwithclass")
    public  WebElement btnLogin;

    public LoginPage(){
        PageFactory.initElements(driver,this);
    }


}
