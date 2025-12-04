
CREATE INDEX idx_orders_user_id
    ON instacart.orders(user_id);


CREATE INDEX idx_orders_dow_hour
    ON instacart.orders(order_dow, order_hour_of_day);


CREATE INDEX idx_order_products_product_id
    ON instacart.order_products(product_id);

CREATE INDEX idx_products_department_id
    ON instacart.products(department_id);

CREATE INDEX idx_products_aisle_id
    ON instacart.products(aisle_id);

CREATE INDEX idx_order_products_order_id
    ON instacart.order_products(order_id);