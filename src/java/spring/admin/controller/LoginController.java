/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.admin.controller;

import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import spring.ejb.RolesFacadeLocal;
import spring.ejb.UsersFacadeLocal;

import spring.functions.SharedFunctions;

@Controller
public class LoginController {

    UsersFacadeLocal usersFacade = lookupUsersFacadeLocal();

    RolesFacadeLocal rolesFacade = lookupRolesFacadeLocal();
    
    
    
    @Autowired
    SharedFunctions sharedFunc;
    
    @RequestMapping(value = "/admin/login", method = RequestMethod.GET)
    public String login() {
        
        return "admin/login";
    }
    
    @RequestMapping(value = "/admin/login", method = RequestMethod.POST)
//    @ResponseBody
    public String login(ModelMap model,
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            @RequestParam(value = "remember", required = false) Short remember,
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response,
            RedirectAttributes redirectAttributes) {
        
        int error = usersFacade.login(email, sharedFunc.encodePassword(password));
        if (error == 1) {
            session.setAttribute("email", email);
            int id = usersFacade.findUserByEmail(email).getUserID();
            session.setAttribute("uid",id );
            if(remember != null && remember == 1){
                Cookie ckEmail = new Cookie("emailA", email);
                ckEmail.setMaxAge(24*60*60);
                response.addCookie(ckEmail);
                
                Cookie ckPassword = new Cookie("passwordA", sharedFunc.encodePassword(password));
                ckPassword.setMaxAge(24*60*60);
                response.addCookie(ckPassword);
            }
            
            if (session.getAttribute("request_url") == null || ((String) session.getAttribute("request_url")).equals("/admin/logout.html")) {
                session.removeAttribute("request_url");
                return "redirect:/admin/index.html";     
            } else {
                return "redirect:" + session.getAttribute("request_url");
            }
        } else if (error == 2) {
            model.addAttribute("error", "<div class=\"alert alert-danger\">FAILED!. Email Not Matched!</div>");
        } else if (error == 3) {
            model.addAttribute("error", "<div class=\"alert alert-danger\">FAILED!. Access Denied!</div>");
        } else {
            model.addAttribute("error", "<div class=\"alert alert-danger\">FAILED!. Password Not Matched</div>");
        }
        return "admin/login";
    }
    
    @RequestMapping(value = "/admin/logout")
    public String logOut(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        ///Remove Session
        session.removeAttribute("email");
        
        // Remove Cookie
        for (Cookie ck : request.getCookies()) {
            if (ck.getName().equalsIgnoreCase("emailA")) {
                ck.setMaxAge(0);
                response.addCookie(ck);
            }
            if (ck.getName().equalsIgnoreCase("passwordA")) {
                ck.setMaxAge(0);
                response.addCookie(ck);
            }
        }
        return "redirect:/admin/login.html";
    }

    private RolesFacadeLocal lookupRolesFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (RolesFacadeLocal) c.lookup("java:global/ShoeGardenPJ/RolesFacade!spring.ejb.RolesFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    private UsersFacadeLocal lookupUsersFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (UsersFacadeLocal) c.lookup("java:global/ShoeGardenPJ/UsersFacade!spring.ejb.UsersFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    
}
