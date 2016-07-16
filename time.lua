-- http://www.esp8266.com/viewtopic.php?f=19&t=6831
-- http://stackoverflow.com/questions/17872997/how-do-i-convert-seconds-since-epoch-to-current-date-and-time/17889530#17889530

time = {}

time.SecondsPerDay = 24 * 60 * 60
time.SecondsPerYear = 365 * time.SecondsPerDay
time.SecondsPerLeapYear = time.SecondsPerYear + time.SecondsPerDay
time.SecondsPerFourYear = 4 * time.SecondsPerYear + time.SecondsPerDay
-- 1970-01-01 was a Thursday
time.BaseDayInWeek = 4
time.BaseYear = 1970

time.Days = {-1, 30, 58, 89, 119, 150, 180, 211, 242, 272, 303, 333, 364}
time.LpDays = {}
for i = 1, 2 do time.LpDays[i] = time.Days[i] end
for i = 3, 13 do time.LpDays[i] = time.Days[i] + 1 end

function time.gmtime(sec)
	local floor = math.floor
	local year, dayInYear, month, day, dayInWeek, hour, minute, second
	local mdays = time.Days
	second = sec
	-- First calculate the number of four-year-interval, so calculation
	-- of leap year will be simple. Btw, because 2000 IS a leap year and
	-- 2100 is out of range, this formula is so simple.
	year = floor(second / time.SecondsPerFourYear)
	second = second - year * time.SecondsPerFourYear
	year = 4 * year + time.BaseYear         -- 1970, 1974, 1978, ...
	if second >= time.SecondsPerYear then
		year = year + 1           -- 1971, 1975, 1979,...
		second = second - time.SecondsPerYear
		if second >= time.SecondsPerYear then
			year = year + 1       -- 1972, 1976, 1980,... (leap years!)
			second = second - time.SecondsPerYear
			if second >= time.SecondsPerLeapYear then
				year = year + 1   -- 1971, 1975, 1979,...
				second = second - time.SecondsPerLeapYear
			else        -- leap year
				mdays = time.LpDays
			end
		end
	end
	dayInYear = floor( second / time.SecondsPerDay)
	second = second - dayInYear * time.SecondsPerDay
	month = 1
	while mdays[month] < dayInYear do 
		month = month + 1
	end
	month = month - 1
	day = dayInYear - mdays[month]
	-- Calculate day of week. Sunday is 0
	dayInWeek = (floor(sec / time.SecondsPerDay) + time.BaseDayInWeek) % 7
	-- Calculate the time of day from the remaining seconds
	hour = floor(second / 3600)
	second = second - hour * 3600
	minute = floor(second / 60)
	second = second - minute * 60
	return {
		year = year,
		day_in_year = dayInYear + 1,
		month = month,
		day = day,
		day_in_week = dayInWeek,
		hour = hour,
		minute = minute,
		second = second
	}
end

function time.format(stamp)    
	if stamp.second < 10 then
		return string.format("%04d-%02d-%02d %02d:%02d:0%.6f", 
			stamp.year, stamp.month, stamp.day, stamp.hour, stamp.minute, stamp.second)
	else
		return string.format("%04d-%02d-%02d %02d:%02d:%.6f", 
			stamp.year, stamp.month, stamp.day, stamp.hour, stamp.minute, stamp.second)
	end
end

function time.time()
	local sec, usec = rtctime.get()
	return sec + usec / 1e6
end

function time.now()
	return time.gmtime(time.time())
end

function time.stamp()
	return time.format(time.now())
end
