/**
 * A library with needed dataweave utility functions.
 */

%dw 2.0

/**
 * Cleans the provided object of blank strings, null values,
 * empty objects, and empty arrays.
 * @param obj is an Object to clean.
 * @return A cleaned object.
 */
fun clean(obj:Object) = (
    removeNull(
        obj mapObject (value, key, index) -> (
            if (typeOf(value) as String == "Array")
                (key): clean(value)
            else if (typeOf(value) as String == "Object")
                (key): clean(value)
            else if (!isEmpty(value) and value != "")
                (key): value
            else (key): null
        )
    )
)

/**
 * Cleans the provided array of blank strings, null values,
 * empty objects, and empty arrays.
 * @param arr is an Array to clean.
 * @return A cleaned Array.
 */
fun clean(arr:Array) = (
    removeNull(
        arr map (value, index) -> (
            if (typeOf(value) as String == "Array")
                clean(value)
            else if (typeOf(value) as String == "Object")
                clean(value)
            else if (!isEmpty(value) and value != "")
                value
            else null
        )
    )
)

/**
 * Removes all null items from an array.
 * @param arr is an array.
 * @return An array with null items removed.
 */
fun removeNull(arr:Array) = (
    if (!isEmpty(arr))
        arr filter ($ != null and !isEmpty($))
    else []
)

/**
 * Removes all null values from an object.
 * @param obj is an object.
 * @return An object with null values removed.
 */
fun removeNull(obj:Object) = (
    if (!isEmpty(obj))
        obj mapObject (value, key, index) -> 
        (
            (key): value
        ) if (!isEmpty(value))
    else {}
)