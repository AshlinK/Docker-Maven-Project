package BaseTest;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import java.util.concurrent.TimeUnit;

public class BaseTest {

    protected static WebDriver driver;

    @BeforeTest
    public static void launchBrowser() {
        System.setProperty("webdriver.chrome.driver", "C:\\Users\\wtr\\IdeaProjects\\dockerDemo\\resources\\chromedriver");
        driver = new ChromeDriver();
        driver.navigate().to("https://www.toolsqa.com/automation-practice-form/");
        driver.manage().window().maximize();
        driver.manage().timeouts().implicitlyWait(10,TimeUnit.SECONDS) ;
    }



    @AfterTest
    public void teardown() {
        driver.close();
    }

}
