# encoding=UTF-8

$FILEDIR = "F:/__EmuleResult__"
$CATEGORY_HASH = {}

def ctg(c, r)
	$CATEGORY_HASH[c] = r
end

ctg "飘花电影", /飘花电影/u
ctg "Doctor Who", /Doctor\.[wW]ho/
ctg "Not Exist", /not exist/
