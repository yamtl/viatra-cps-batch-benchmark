package experiments.utils

import java.text.SimpleDateFormat
import java.util.Date
import java.util.TimeZone

class GroovyUtil {
	
	// methods taken from Groovy
	def public format(Date date, String format, TimeZone tz) {
		val sdf = new SimpleDateFormat("yyyyMMdd-HHmm")
        sdf.setTimeZone(TimeZone.getTimeZone('UTC'))
        sdf.format(date)
    }
	
	def public String padLeft(CharSequence self_, Number numberOfChars, CharSequence padding) {
        var int numChars = numberOfChars.intValue();
        if (numChars <= self_.length()) {
            return self_.toString();
        } else {
            return getPadding(padding.toString(), numChars - self_.length()) + self_;
        }
    }
	
	def private String getPadding(CharSequence padding, int length) {
        if (padding.length() < length) {
            return multiply(padding, length / padding.length() + 1).substring(0, length);
        } else {
            return "" + padding.subSequence(0, length);
        }
    }
    
    def public String multiply(CharSequence self_, Number factor) {
        var int size = factor.intValue();
        if (size == 0)
            return ""
        else if (size < 0) {
            throw new IllegalArgumentException("multiply() should be called with a number of 0 or greater not: " + size);
        }
        var StringBuilder answer = new StringBuilder(self_);
        for (var int i = 1; i < size; i++) {
            answer.append(self_);
        }
        return answer.toString();
    }
    
}