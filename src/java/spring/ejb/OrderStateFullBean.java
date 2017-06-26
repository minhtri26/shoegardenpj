/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package spring.ejb;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.ejb.Remove;
import javax.ejb.Stateful;
import javax.ejb.StatefulTimeout;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import spring.entity.CartLineInfo;
import spring.entity.Orders;
import spring.entity.OrdersDetail;
import spring.entity.SizesByColor;

/**
 *
 * @author tuan
 */
@Stateful
public class OrderStateFullBean implements OrderStateFullBeanLocal, Serializable  {

    @EJB
    private ProductsFacadeLocal productsFacade;

    @EJB
    private OrderStateLessBeanLocal orderStateLessBean;
    
    

    @PersistenceContext
    private EntityManager em;

    public EntityManager getEntityManager() {
        return em;
    }

    private List<CartLineInfo> cart;

    @PostConstruct
    public void init() {
        cart = new ArrayList<>();
    }

    @Override
    public void addProduct(CartLineInfo cartLineInfo) {
        CartLineInfo oldCartLineInfo = getProductInListByID(cartLineInfo.getProduct().getProductID(),
                  cartLineInfo.getSizesByColor().getSizeID(),
                  cartLineInfo.getSizesByColor().getColorID().getColorID());
        if (oldCartLineInfo != null) {
            cartLineInfo.setQuantity(oldCartLineInfo.getQuantity() + cartLineInfo.getQuantity());
            cart.set(cart.indexOf(oldCartLineInfo), cartLineInfo);
            return;
        } else {
            cart.add(cartLineInfo);
        }
    }

    @Override
    public boolean deleteProduct(CartLineInfo cartLineInfo) {
        if (cartLineInfo != null) {
            cart.remove(cartLineInfo);
            return true;
        }
        return false;
    }

    @Override
    public List<CartLineInfo> showCart() {
        return cart;
    }

    @Override
    public CartLineInfo getProductInListByID(int productid, int sizeid, int colorid) {
        for (CartLineInfo cartLineInfo : cart) {
            if (cartLineInfo.getProduct().getProductID().equals(productid)) {
                if (cartLineInfo.getSizesByColor().getSizeID().equals(sizeid)
                          && cartLineInfo.getSizesByColor().getColorID().getColorID().equals(colorid)) {
                    return cartLineInfo;
                }
            }
        }
        return null;
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public String completePurchase(Orders orders) {
        String checkError;
        try {
            List<OrdersDetail> ordersDetailList = new ArrayList<>();
            
            
            for (CartLineInfo cartLineInfo : cart) {
                
                SizesByColor sbc = orderStateLessBean.getSizesByColorBySizeIDandColorID(cartLineInfo.getSizesByColor().getSizeID(), cartLineInfo.getSizesByColor().getColorID().getColorID());
                
                OrdersDetail ordersDetail = new OrdersDetail();
                ordersDetail.setOrdersID(orders);
                ordersDetail.setProductID(cartLineInfo.getProduct());
                ordersDetail.setSizeID(cartLineInfo.getSizesByColor());
                ordersDetail.setProductDiscount((short) cartLineInfo.getProduct().getDiscountByProduct());
                
                ordersDetail.setQuantity(cartLineInfo.getQuantity());
                ordersDetail.setPrice(cartLineInfo.getProduct().getPrice());
                ordersDetail.setStatus(Short.parseShort("0"));
                ordersDetailList.add(ordersDetail);
                
                if(sbc.getQuantity()<=0||cartLineInfo.getQuantity()>sbc.getQuantity()){//kiem tra so luong ton kho co > so luong trong cart
                    sbc.setQuantity(0);
                    checkError = String.valueOf("000");
                    return checkError;
                }else
                    sbc.setQuantity(sbc.getQuantity() - cartLineInfo.getQuantity());
                
                getEntityManager().merge(sbc);
                getEntityManager().flush();
                
                
            }
            orders.setOrderDetailList(ordersDetailList);
            getEntityManager().persist(orders);
            getEntityManager().flush();
            checkError = String.valueOf(orders.getOrdersID());
        } catch (Exception e) {
            e.printStackTrace();
            checkError = String.valueOf("000");
        }
        cart = new ArrayList<>();
        return checkError;
    }

    @Override
    public float subTotal() {
        float subtotal = 0;
        for (CartLineInfo cartLineInfo : cart) {
            subtotal += cartLineInfo.getSubTotal();
        }
        return subtotal;
    }

    @Override
    public boolean updateProduct(CartLineInfo oldCartLineInfo, CartLineInfo cartLineInfo) {
        try {
            cart.set(cart.indexOf(oldCartLineInfo), cartLineInfo);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    @Remove
    public void remove() {
        cart = new ArrayList<>();
    }
}
