package cl.fibertrack.auth;
import cl.fibertrack.common.ApiException; import cl.fibertrack.security.PrincipalUser; import cl.fibertrack.user.UserRepository; import jakarta.validation.Valid; import lombok.RequiredArgsConstructor; import org.springframework.http.HttpStatus; import org.springframework.security.core.annotation.AuthenticationPrincipal; import org.springframework.web.bind.annotation.*; import java.util.*;
@RestController @RequestMapping("/api/v1/auth") @RequiredArgsConstructor public class AuthController {
 private final AuthService auth; private final UserRepository users;
 @PostMapping("/login") AuthDtos.Tokens login(@Valid @RequestBody AuthDtos.Login r){return auth.login(r);} @PostMapping("/refresh") AuthDtos.Tokens refresh(@Valid @RequestBody AuthDtos.Refresh r){return auth.refresh(r.refreshToken());}
 @GetMapping("/me") AuthDtos.UserView me(@AuthenticationPrincipal PrincipalUser p){return auth.view(users.findById(p.id()).orElseThrow());}
 @PostMapping("/logout") void logout(@AuthenticationPrincipal PrincipalUser p,@Valid @RequestBody AuthDtos.Refresh r){auth.logout(p.id(),r.refreshToken());}
 @PostMapping("/password/request") Map<String,String> request(@Valid @RequestBody AuthDtos.PasswordRequest r){return Map.of("message",auth.requestPassword(r.email()));}
 @PostMapping("/password/reset") void reset(@Valid @RequestBody AuthDtos.PasswordReset r){auth.resetPassword(r.token(),r.password());}
 @PostMapping("/password/change") void change(@AuthenticationPrincipal PrincipalUser p,@Valid @RequestBody AuthDtos.PasswordChange r){auth.changePassword(users.findById(p.id()).orElseThrow(()->new ApiException(HttpStatus.UNAUTHORIZED,"Sesión inválida")),r.currentPassword(),r.newPassword());}
}

