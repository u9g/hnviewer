let units =
	year  : 24 * 60 * 60 * 1000 * 365,
	month : 24 * 60 * 60 * 1000 * 365/12,
	day   : 24 * 60 * 60 * 1000,
	hour  : 60 * 60 * 1000,
	minute: 60 * 1000,
	second: 1000

const rtf = new Intl.RelativeTimeFormat 'en', 
	numeric: 'auto'
	style: 'narrow'

export def getRelativeTime(d1\Date)
	const elapsed = d1.getTime() - new Date(Date.now()).getTime()

	# "Math.abs" accounts for both "past" & "future" scenarios
	for own unit, ms of units
		if (Math.abs(elapsed) > ms || unit === 'second') 
			// @ts-ignore
			return rtf.format(Math.round(elapsed/ms), unit)