
<%@page import="java.math.RoundingMode"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="spring.entity.Orders"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- BREADCRUMBS -->
<jsp:include page="../blocks/breadcrumbs.jsp" flush="true" />

<!-- MY ACCOUNT -->
<div class="account-wrap">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <!-- HTML -->
                <div id="account-id">
                    <h4 class="account-title">
                        <span class="fa fa-chevron-right"></span>Order Details For Order NO.${order.ordersID}
                    </h4>                                                                    
                    <div class="order-history">
                        <table class="cart-table">
                            <thead>
                                <tr>
                                    <th style="font-weight: 700;">Order Date</th>
                                    <td><fmt:formatDate value="${order.ordersDate}" pattern="dd-MM-yyyy hh:mm:ss"/></td>
                                </tr>
                                <tr>
                                    <th style="font-weight: 700;">Ship to</th>
                                    <td>${order.receiverFirstName} ${order.receiverLastName}</td>
                                </tr>
                                <tr>
                                    <th style="font-weight: 700;">Address</th>
                                    <td>${order.deliveryAddress}</td>
                                </tr>
                                <tr>
                                    <th style="font-weight: 700;">Phone</th>
                                    <td>${order.phoneNumber}</td>
                                </tr>
                                <tr>
                                    <th style="font-weight: 700;">Order Note</th>
                                    <td>${order.note}</td>
                                </tr>
                            </thead>
                            <tbody>

                            </tbody>
                        </table>
                    </div><br/>
                    <div class="order-history">
                        <table class="cart-table">
                            <thead>
                                <tr>
                                    <th style="font-weight: 700;">Product Name</th>
                                    <th style="font-weight: 700;">Color</th>
                                    <th style="font-weight: 700;">Size</th>
                                    <th style="font-weight: 700;">Quantity</th>
                                    <th style="font-weight: 700;">Price for one</th>
                                    <th style="font-weight: 700;">Product discount</th>
                                    <th style="font-weight: 700;">SubTotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orderdetailList}" var="orderdetail">
                                    <tr>
                                        <td class="text-center fs-valign-middle">
                                            <a href="${orderdetail.productID.productID}-${orderdetail.productID.productColorsList[0].colorID}.html">
                                                ${orderdetail.productID.productName}
                                            </a>
                                        </td>
                                        <td class="text-center fs-valign-middle">${orderdetail.sizeID.colorID.color}</td>
                                        <td class="text-center fs-valign-middle" style="width: 50px;">${orderdetail.sizeID.size}</td>
                                        <td class="text-center fs-valign-middle">${orderdetail.quantity}</td>
                                        <td class="text-center fs-valign-middle">$${orderdetail.price}</td>
                                        <td class="text-center fs-valign-middle">${orderdetail.productDiscount}%</td>
                                        <td class="text-center fs-valign-middle">$${orderdetail.getSubTotal()}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="6" style="padding-left: 770px;"><b>Payment Total</b></td>
                                    <td align="center">$${order.getPaymentTotal()}</td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                    <div class="clearfix space10"></div>
                    <c:if test="${order.status == 2}">
                        <div class="order-history">
                            <button class="btn btn-danger pull-right" 
                                    id="btnClientCancelOrder" 
                                    data-href="orders/cancelorder/${order.ordersID}.html"
                                    data-toggle="modal" 
                                    data-target="#confirm-cancel-order">CANCEL ORDER</button>
                        </div>
                    </c:if>
                    <div class="order-history">
                        <button class="btn btn-primary pull-right" onclick="window.location = 'orders/order-history.html'">BACK TO ORDER HISTORY LIST</button>
                    </div>
                </div>
                <div class="modal fade" id="confirm-cancel-order" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">

                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                <h4 class="modal-title" id="myModalLabel">Confirm Cancel Order</h4>
                            </div>

                            <div class="modal-body">
                                <p>Do you want to proceed?</p>
                                <p class="debug-url"></p>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                                <a class="btn btn-danger btn-cancel-order-ok">OK</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>                        
        </div>
    </div>
</div>
<div class="clearfix space20"></div>