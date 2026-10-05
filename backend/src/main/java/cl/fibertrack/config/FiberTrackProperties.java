package cl.fibertrack.config;
import org.springframework.boot.context.properties.ConfigurationProperties;
@ConfigurationProperties("fibertrack")
public record FiberTrackProperties(Jwt jwt, Owner owner, String mailFrom, String publicUrl) {
  public record Jwt(String secret,long accessSeconds,long refreshSeconds){}
  public record Owner(String email,String password){}
}

