class CombineItemsInCart < ActiveRecord::Migration
  def change
    def up  
    # replace multiple items for a single product in a cart with single items
      Cart.all.each do |cart|
        # count the number of each product in a cart
        sums = cart.line_items.group(:product_id).sum(:quantity)

        sums.each do |product_id, quantity|
          if quantity > 1
            # remove individual items
            cart.line_items.where(product_id: product_id).delete.all
            # replace with single item
            item = cart.line_items.build(product_id: product_id)
            item.quantity = quantity
            item.save!
          end
        end  
      end
    end
  end
end
