create or replace view v_venda
as
select nome_cliente, "Valor Venda", "Valor Total"
from (
select 1 as ordem, nome_cliente, to_char(item_pedido.valor_venda,'999D99') as "Valor Venda",    
       (item_pedido.quantidade * item_pedido.valor_venda) as "Valor Total"
from  cliente , pedido  , item_pedido , produto 
where cliente.codigo_cliente = pedido.codigo_cliente
  and pedido.num_pedido = item_pedido.num_pedido
  and item_pedido.codigo_produto = produto.codigo_produto  
UNION 
select 2 as ordem,'', '', sum(item_pedido.quantidade * item_pedido.valor_venda) as "Valor Total da Venda"
from  cliente , pedido  , item_pedido , produto 
where cliente.codigo_cliente = pedido.codigo_cliente
  and pedido.num_pedido = item_pedido.num_pedido
  and item_pedido.codigo_produto = produto.codigo_produto) venda
order by ordem;

select * from v_venda;