<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Page Content -->
<div id="page-wrapper">
    <div class="container-fluid" id="fs-discount-add-page">
        <div class="row">
            <div class="col-lg-12">

                <h1 class="page-header"> 
                    <strong>Discount</strong> 
                    <i class="fa fa-caret-right fa-style" aria-hidden="true" style="color: #337ab7"></i> 
                    <span style="font-size: 0.9em">Create New</span>
                </h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->

        <div class="row">
            <div class="col-lg-12">
                <div id="error-discount-add">
                    ${error}
                </div>
               
                <div class="row">

                    <form:form id="fs-form-create-discount" name="discount-add-form" method="POST" modelAttribute="discount">

                        <fieldset class="form-group" id="fs-fieldset-discount">

                            <div class="col-lg-12">
                                <!--<legend class="text-center">Discount</legend>-->
                                <div class="col-xs-12" style="margin-bottom: 10px">
                                    <span style="color: red; font-size: 13px">
                                        <i>* Required Field!</i>
                                    </span>
                                </div>
                                <div class="col-md-5">

                                    <div class="form-group">
                                        <label>Discount Title <span class="fs-color-red">*</span></label>
                                        <p class="help-block" id="fs-discount-title-error"></p>

                                        <form:input path="discTitle" id="fs-discount-title" cssClass="form-control" placeholder="Enter Title Name" />
                                    </div>

                                    <div class="form-group">
                                        <label>Discount<span class="fs-color-red">*</span></label>
                                        <p class="help-block" id="fs-discount-error"></p>
                                        <span class="input-group">

                                            <form:input style="position: relative; z-index: 50000;" path="discount" id="fs-discount" cssClass="form-control" placeholder="Discount" />
                                            <span class="input-group-addon"><i class="fa fa-percent" aria-hidden="true"></i></span>
                                        </span>
                                    </div>

                                    <div class="form-group">
                                        <label>Begin Date<span class="fs-color-red">*</span></label>
                                        <p class="help-block" id="fs-bDate-error"></p>
                                        <form:input cssClass="form-control" path="dateBegin" onkeydown="return false"/>


                                    </div>
                                    <div class="form-group">
                                        <label>End Date<span class="fs-color-red">*</span></label>

                                        <form:input cssClass="form-control" path="dateEnd" onkeydown="return false"/>
                                    </div>
                                    <p class="help-block" id="fs-eDate-error"></p>

                                </div>
                                <div class="col-md-7">
                                    <div class="form-group">
                                        <div class="form-group">
                                            <label for="description">Content</label>
                                            <p class="help-block" id="fs-content-error"></p>

                                            <form:textarea path="discContent" id="fs-product-description" cssClass="form-control" placeholder="Enter Content" />
                                        </div>


                                    </div>
                                </div>



                            </div>
                        </fieldset>
<!--                        <legend class="text-center">Discount Detail</legend>-->
                        <div class="col-xs-12" style="margin-bottom: 10px">
                            <span style="color: red; font-size: 13px">
                                <i>* Click on rows to select products!</i>
                            </span>
                        </div>
                        <div class="row fs-div-product-list-select-box" > 
                            <div class="col-lg-12">
                                <table width="100%" class="table table-striped table-bordered table-hover cc" id="fs-discount-addnew">
                                    <thead>
                                        <tr>
                                            <th class="text-center fs-valign-middle">ID</th>
                                            <th class="text-center fs-valign-middle">Status</th>
                                            <th class="text-center fs-valign-middle">Category - SubCategory</th>
                                            <th class="text-center fs-valign-middle">Product</th>
                                            <th class="text-center fs-valign-middle">Image</th>
                                            <th class="text-center fs-valign-middle">Posted Date</th>

                                        </tr>
                                    </thead>

                                    <tbody>
                                        <c:forEach items="${productList}" var="product" varStatus="No">
                                            <tr>
                                                <td class="text-center fs-valign-middle" data-jtable="${product.productID}">${product.productID}</td>
                                                <c:if test="${product.status == 1}">
                                                    <td class="text-center fs-valign-middle">WORKING</td>
                                                </c:if>
                                                <c:if test="${product.status == 0}">
                                                    <td class="text-center fs-valign-middle">STOPPED</td>
                                                </c:if>

                                                <td class="text-center fs-valign-middle">${product.braID.braName} - ${product.catID.catName}</td>
                                                <td class="text-center fs-valign-middle">${product.productName}</td>
                                                <td class="text-center fs-valign-middle">
                                                    <img class="responsive" style="width: 100px" src="assets/images/products/${product.urlImg}" alt="${product.urlImg}"/>
                                                </td>
                                                <td class="text-center fs-valign-middle">
                                                    <fmt:formatDate pattern="dd/MM/yyyy" value="${product.postedDate}"/>
                                                </td>


                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <!-- /.table-responsive -->
                            </div>
                            <div class="col-xs-12">
                                <hr>
                                <div class="form-group text-right">

                                    <button type="reset" class="btn btn-default" title="Reset to default">
                                        <i class="fa fa-undo" aria-hidden="true"></i> Reset
                                    </button>

                                    <button type="submit" class="btn btn-success" id="fs-btn-create-new-discount" title="Create New Discount">
                                        <i class="fa fa-plus-circle" aria-hidden="true"></i> Create
                                    </button>                               
                                </div>   
                            </div>

                        </div>
                    </form:form>

                </div>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
    </div>
    <!-- /.container-fluid -->
</div>
<!-- /#page-wrapper -->
