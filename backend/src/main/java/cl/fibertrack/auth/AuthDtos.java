package cl.fibertrack.auth;
import jakarta.validation.constraints.*; import java.util.*;
public final class AuthDtos {
 private AuthDtos(){}
 public record Login(@Email @NotBlank String email,@NotBlank String password,String deviceName,String devicePlatform){}
 public record Refresh(@NotBlank String refreshToken){}
 public record Tokens(String accessToken,String refreshToken,long expiresIn,UserView user){}
 public record UserView(UUID id,String nombre,String apellido,String email,boolean owner,Set<String> roles,Set<String> permissions){}
 public record PasswordRequest(@Email @NotBlank String email){}
 public record PasswordReset(@NotBlank String token,@Size(min=10,max=128) String password){}
 public record PasswordChange(@NotBlank String currentPassword,@Size(min=10,max=128) String newPassword){}
}

