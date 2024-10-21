
--- inventory tracking 

CREATE PROC inventory_item @product INT, @quantity_sold SMALLINT, @store SMALLINT
AS
BEGIN
    DECLARE @product_level INT;
    BEGIN TRY
        BEGIN TRANSACTION
            SELECT @product_level = quantity 
            FROM production.inventory_levels
            WHERE product_id = @product AND store_id = @store;

            IF @product_level >= @quantity_sold
                BEGIN
                    UPDATE production.inventory_levels
                    SET quantity = quantity - @quantity_sold
                   WHERE product_id = @product AND store_id = @store;
                COMMIT TRANSACTION;
                END
            ELSE
                BEGIN
                ROLLBACK TRANSACTION;
                RAISERROR('Not enough stock to fulfill the sale', 16, 1);
                END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            DECLARE @ErrorMessage NVARCHAR(4000);
        SELECT @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
    SELECT *
    FROM production.inventory_levels
    WHERE product_id = @product AND store_id = @store;
    
END;


---- inventory check
CREATE FUNCTION inventory_check()
RETURNS TABLE
AS 
RETURN(
    SELECT *
    FROM production.inventory_levels
    WHERE quantity < 5
);


--- daily report

CREATE PROC dailyReport (@order_date date)
AS 
BEGIN
    SELECT product_name, SUM(quantity) AS Total_quantity
    FROM sales.orders AS O
    JOIN sales.order_items AS OI
    ON o.order_id = oi.order_id
    JOIN production.products AS P
    ON OI.product_id = P.product_id
    WHERE order_date = @order_date
    GROUP BY product_name
    ORDER BY Total_quantity;


    SELECT product_name, SUM(OI.list_price) AS Total_sales
    FROM sales.orders AS O
    JOIN sales.order_items AS OI
    ON o.order_id = oi.order_id
    JOIN production.products AS P
    ON OI.product_id = P.product_id
    WHERE order_date = @order_date
    GROUP BY product_name
    ORDER BY Total_sales;

END;