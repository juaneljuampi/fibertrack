package cl.fibertrack.security;
import cl.fibertrack.user.User; import org.springframework.security.core.*; import org.springframework.security.core.authority.*; import org.springframework.security.core.userdetails.UserDetails; import java.util.*;
public record PrincipalUser(UUID id,String email,String password,boolean active,boolean owner,Collection<? extends GrantedAuthority> authorities) implements UserDetails {
 public static PrincipalUser from(User u){ var a=new ArrayList<GrantedAuthority>(); u.effectivePermissions().forEach(p->a.add(new SimpleGrantedAuthority(p))); u.getRoles().forEach(r->a.add(new SimpleGrantedAuthority("ROLE_"+r.getCodigo()))); if(u.isOwner()) a.add(new SimpleGrantedAuthority("OWNER")); return new PrincipalUser(u.getId(),u.getEmail(),u.getPasswordHash(),u.isActivo(),u.isOwner(),a); }
 public String getUsername(){return email;} public String getPassword(){return password;} public boolean isAccountNonExpired(){return true;} public boolean isAccountNonLocked(){return true;} public boolean isCredentialsNonExpired(){return true;} public boolean isEnabled(){return active;}
 public Collection<? extends GrantedAuthority> getAuthorities(){return authorities;}
}
