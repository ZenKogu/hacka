@prelude__init=~> this[it] = prelude[it]
prelude.each prelude__init, <[ is-type abs acos all and-list any apply asin at atan atan2 average break-list break-str camelize capitalize ceiling chars compact concat concat-map cos count-by curry dasherize difference drop drop-while each elem-index elem-indices empty even exp filter find find-index find-indices first fix flatten flip floor fold fold1 foldl foldl1 foldr foldr1 Func gcd group-by initial intersection is-it-NaN join keys last lcm lines lists-to-obj ln map max maximum maximum-by mean memoize min minimum minimum-by mod negate Num Obj obj-to-lists obj-to-pairs odd or-list over pairs-to-obj partition pi pow product quot recip reject reject rem repeat reverse replicate	 round scan scan1 scanl scanl1 scanr scanr1 signum sin slice sort sort-by sort-with split split-at sqrt Str sum tail take take-while tan tau truncate unchars unfoldr union unique unique-by unlines unwords values words zip zip-all zip-all-with zip-with ]>
@contains 		= _.contains

@xml=(o={tag:\div self:false})->(opts,...inner)~> switch
	| !o.self*opts?length => "<#{o.tag}>#opts #{inner*' '}</#{o.tag}>"
	| !o.self*!opts?length=> '<'+o.tag+[" #{i}=\"#{opts[i]}\"" for i of opts]+">#{inner*' '}</#{o.tag}>"		 
	| _=> '<'+o.tag+[" #i=\"#{opts[i]}\"" for i of opts]+\/>
	
@xml__init=(self)~>(tag)~>this[tag]=xml {tag, self}
each xml__init(false), <[ div span a p h4 h3 h2 h1 button table thead tr th tbody td small ul ol li span label select option textarea form output i sub time section html head body title script footer header article link nav figure figcaption tfoot video source type iframe ]>
each xml__init(true), <[ input link img meta source br hr ]>

