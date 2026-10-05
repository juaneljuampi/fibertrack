package cl.fibertrack.security;
import cl.fibertrack.user.UserRepository; import jakarta.servlet.*; import jakarta.servlet.http.*; import lombok.RequiredArgsConstructor; import org.springframework.security.authentication.*; import org.springframework.security.core.context.SecurityContextHolder; import org.springframework.stereotype.Component; import org.springframework.web.filter.OncePerRequestFilter; import java.io.IOException;
@Component @RequiredArgsConstructor public class JwtFilter extends OncePerRequestFilter {
 private final JwtService jwt; private final UserRepository users;
 protected void doFilterInternal(HttpServletRequest req,HttpServletResponse res,FilterChain chain)throws ServletException,IOException { var h=req.getHeader("Authorization"); if(h!=null&&h.startsWith("Bearer ")) try { var u=users.findById(jwt.subject(h.substring(7))).orElseThrow(); if(u.isActivo()&&u.getDeletedAt()==null){var p=PrincipalUser.from(u); SecurityContextHolder.getContext().setAuthentication(new UsernamePasswordAuthenticationToken(p,null,p.authorities()));}} catch(Exception ignored){} chain.doFilter(req,res); }
}

