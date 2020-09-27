function getQuote{
  ### Construct and execute web request for random quote
	$rand = get-random -min 2 -max 80000
	$quoteurl = "https://www.quotes.net/quote/$rand" 
	$webrequest = (Invoke-WebRequest -URI $quoteurl -UseBasicParsing -TimeoutSec 60)

	if($webrequest.StatusCode -eq 200){
		### Get quote from raw content, using a regex
		###   -NOTE: Some pages just say Quotes.net in title...
		[regex]$regex = '\<title\>.*\<\/title\>'
		$rawquote = $regex.Matches($webrequest.RawContent).Value
		
		### Strip out HTML tags and make quote a global var
		$quotelen = $rawquote.length
		$quotearray = $rawquote[7..($quotelen-9)]
		$global:quote = $quotearray -join ''
	}

}

### Some pages do not contain quotes, so we need to double check before exiting the program
function testQuote($quote){
	if($quote -eq "Quotes.net"){
		return $False
	}
	else{
		return $True
	}
}

$goodQuote = $False
while($goodQuote -eq $False){
	getQuote
	$goodQuote = testQuote($quote)
	if($goodQuote -eq $True){
		write-host $quote
	}
}
