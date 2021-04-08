import java.io.IOException;
import org.apache.http.client.fluent.*;

public class makeAbstractRequest
{
public static void main(String[] args) {
    makeAbstractRequest();
}

private static void makeAbstractRequest() {

    try {

        Content content = Request.Get('https://ipgeolocation.abstractapi.com/v1?api_key=286e580a464848a5ab14d335d349a5f2')

        .execute().returnContent();

        System.out.println(content);
    }
    catch (IOException error) { System.out.println(error); }
}
}