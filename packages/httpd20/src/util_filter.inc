{ Copyright 2000-2005 The Apache Software Foundation or its licensors, as
 * applicable.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 }

{#include "apr.h"
#include "apr_buckets.h"

#include "httpd.h"

#if APR_HAVE_STDARG_H
#include <stdarg.h>
#endif}

{
 * @file util_filter.h
 * @brief Apache filter library
 }

const
{ Returned by the bottom-most filter if no data was written.
 *  @see ap_pass_brigade(). }
  AP_NOBODY_WROTE        = -1;
{ Returned by the bottom-most filter if no data was read.
 *  @see ap_get_brigade(). }
  AP_NOBODY_READ         = -2;
{ Returned when?? @bug find out when! }
  AP_FILTER_ERROR        = -3;

{
 * input filtering modes
 }
type
  ap_input_mode_t = (
    { The filter should return at most readbytes data. }
    AP_MODE_READBYTES,
    { The filter should return at most one line of CRLF data.
     *  (If a potential line is too long or no CRLF is found, the 
     *   filter may return partial data).
     }
    AP_MODE_GETLINE,
    { The filter should implicitly eat any CRLF pairs that it sees. }
    AP_MODE_EATCRLF,
    { The filter read should be treated as speculative and any returned
     *  data should be stored for later retrieval in another mode. }
    AP_MODE_SPECULATIVE,
    { The filter read should be exhaustive and read until it can not
     *  read any more.
     *  Use this mode with extreme caution.
     }
    AP_MODE_EXHAUSTIVE,
    { The filter should initialize the connection if needed,
     *  NNTP or FTP over SSL for example.
     }
    AP_MODE_INIT
  );

{
 * @defgroup filter FILTER CHAIN
 *
 * Filters operate using a "chaining" mechanism. The filters are chained
 * together into a sequence. When output is generated, it is passed through
 * each of the filters on this chain, until it reaches the end (or "bottom")
 * and is placed onto the network.
 *
 * The top of the chain, the code generating the output, is typically called
 * a "content generator." The content generator's output is fed into the
 * filter chain using the standard Apache output mechanisms: ap_rputs(),
 * ap_rprintf(), ap_rwrite(), etc.
 *
 * Each filter is defined by a callback. This callback takes the output from
 * the previous filter (or the content generator if there is no previous
 * filter), operates on it, and passes the result to the next filter in the
 * chain. This pass-off is performed using the ap_fc_* functions, such as
 * ap_fc_puts(), ap_fc_printf(), ap_fc_write(), etc.
 *
 * When content generation is complete, the system will pass an "end of
 * stream" marker into the filter chain. The filters will use this to flush
 * out any internal state and to detect incomplete syntax (for example, an
 * unterminated SSI directive).
 }

{ forward declare the filter type }
  Pap_filter_t = ^ap_filter_t;

{
 * @name Filter callbacks
 *
 * This function type is used for filter callbacks. It will be passed a
 * pointer to "this" filter, and a "bucket" containing the content to be
 * filtered.
 *
 * In filter->ctx, the callback will find its context. This context is
 * provided here, so that a filter may be installed multiple times, each
 * receiving its own per-install context pointer.
 *
 * Callbacks are associated with a filter definition, which is specified
 * by name. See ap_register_input_filter() and ap_register_output_filter()
 * for setting the association between a name for a filter and its 
 * associated callback (and other information).
 *
 * If the initialization function argument passed to the registration
 * functions is non-NULL, it will be called iff the filter is in the input
 * or output filter chains and before any data is generated to allow the
 * filter to prepare for processing.
 *
 * The *bucket structure (and all those referenced by ->next and ->prev)
 * should be considered "const". The filter is allowed to modify the
 * next/prev to insert/remove/replace elements in the bucket list, but
 * the types and values of the individual buckets should not be altered.
 *
 * For the input and output filters, the return value of a filter should be
 * an APR status value.  For the init function, the return value should
 * be an HTTP error code or OK if it was successful.
 * 
 * @ingroup filter
 }

  ap_out_filter_func = function (f: Pap_filter_t;
   b: Papr_bucket_brigade): apr_status_t;

  ap_in_filter_func = function (f: Pap_filter_t;
   b: Papr_bucket_brigade; mode: ap_input_mode_t;
   block: apr_read_type_e; readbytes: apr_off_t): apr_status_t;
                                          
  ap_init_filter_func = function (f: Pap_filter_t): Integer;

  ap_filter_func = record
    Case Integer of
     0: (out_func: ap_out_filter_func);
     1: (in_func: ap_in_filter_func);
  end;

{
 * Filters have different types/classifications. These are used to group
 * and sort the filters to properly sequence their operation.
 *
 * The types have a particular sort order, which allows us to insert them
 * into the filter chain in a determistic order. Within a particular grouping,
 * the ordering is equivalent to the order of calls to ap_add_*_filter().
 }
  ap_filter_type = (
    { These filters are used to alter the content that is passed through
     *  them. Examples are SSI or PHP. }
    AP_FTYPE_RESOURCE     = 10,
    { These filters are used to alter the content as a whole, but after all
     *  AP_FTYPE_RESOURCE filters are executed.  These filters should not
     *  change the content-type.  An example is deflate.  }
    AP_FTYPE_CONTENT_SET  = 20,
    { These filters are used to handle the protocol between server and
     *  client.  Examples are HTTP and POP. }
    AP_FTYPE_PROTOCOL     = 30,
    { These filters implement transport encodings (e.g., chunking). }
    AP_FTYPE_TRANSCODE    = 40,
    { These filters will alter the content, but in ways that are
     *  more strongly associated with the connection.  Examples are
     *  splitting an HTTP connection into multiple requests and
     *  buffering HTTP responses across multiple requests.
     *
     *  It is important to note that these types of filters are not
     *  allowed in a sub-request. A sub-request's output can certainly
     *  be filtered by ::AP_FTYPE_RESOURCE filters, but all of the "final
     *  processing" is determined by the main request. }
    AP_FTYPE_CONNECTION  = 50,
    { These filters don't alter the content.  They are responsible for
     *  sending/receiving data to/from the client. }
    AP_FTYPE_NETWORK     = 60
  );

{
 * This is the request-time context structure for an installed filter (in
 * the output filter chain). It provides the callback to use for filtering,
 * the request this filter is associated with (which is important when
 * an output chain also includes sub-request filters), the context for this
 * installed filter, and the filter ordering/chaining fields.
 *
 * Filter callbacks are free to use ->ctx as they please, to store context
 * during the filter process. Generally, this is superior over associating
 * the state directly with the request. A callback should not change any of
 * the other fields.
 }

  Pap_filter_rec_t = ^ap_filter_rec_t;

{
 * This structure is used for recording information about the
 * registered filters. It associates a name with the filter's callback
 * and filter type.
 *
 * At the moment, these are simply linked in a chain, so a ->next pointer
 * is available.
 }
  ap_filter_rec_t = record
    { The registered name for this filter }
    name: PAnsiChar;
    { The function to call when this filter is invoked. }
    filter_func: ap_filter_func;
    { The function to call before the handlers are invoked. Notice
     * that this function is called only for filters participating in
     * the http protocol. Filters for other protocols are to be
     * initiliazed by the protocols themselves. }
    filter_init_func: ap_init_filter_func;
    { The type of filter, either AP_FTYPE_CONTENT or AP_FTYPE_CONNECTION.
     * An AP_FTYPE_CONTENT filter modifies the data based on information 
     * found in the content.  An AP_FTYPE_CONNECTION filter modifies the 
     * data based on the type of connection.
     }
    ftype: ap_filter_type;

    { The next filter_rec in the list }
    next: Pap_filter_rec_t;
  end;

{
 * The representation of a filter chain.  Each request has a list
 * of these structures which are called in turn to filter the data.  Sub
 * requests get an exact copy of the main requests filter chain.
 }
  ap_filter_t = record
    { The internal representation of this filter.  This includes
     *  the filter's name, type, and the actual function pointer.
     }
    frec: Pap_filter_rec_t;

    { A place to store any data associated with the current filter }
    ctx: Pointer;

    { The next filter in the chain }
    next: Pap_filter_t;

    { The request_rec associated with the current filter.  If a sub-request
     *  adds filters, then the sub-request is the request associated with the
     *  filter.
     }
    r: Prequest_rec;

    { The conn_rec associated with the current filter.  This is analogous
     *  to the request_rec, except that it is used for input filtering.
     }
    c: Pconn_rec;
  end;

{
 * Get the current bucket brigade from the next filter on the filter
 * stack.  The filter returns an apr_status_t value.  If the bottom-most 
 * filter doesn't read from the network, then ::AP_NOBODY_READ is returned.
 * The bucket brigade will be empty when there is nothing left to get.
 * @param filter The next filter in the chain
 * @param bucket The current bucket brigade.  The original brigade passed
 *               to ap_get_brigade() must be empty.
 * @param mode   The way in which the data should be read
 * @param block  How the operations should be performed
 *               ::APR_BLOCK_READ, ::APR_NONBLOCK_READ
 * @param readbytes How many bytes to read from the next filter.
 }
function ap_get_brigade(filter: Pap_filter_t;
 bucket: Papr_bucket_brigade; mode: ap_input_mode_t;
 block: apr_read_type_e; readbytes: apr_off_t): apr_status_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_get_brigade' + LibSuff24;

{
 * Pass the current bucket brigade down to the next filter on the filter
 * stack.  The filter returns an apr_status_t value.  If the bottom-most 
 * filter doesn't write to the network, then ::AP_NOBODY_WROTE is returned.
 * The caller relinquishes ownership of the brigade.
 * @param filter The next filter in the chain
 * @param bucket The current bucket brigade
 }
function ap_pass_brigade(filter: Pap_filter_t;
 bucket: Papr_bucket_brigade): apr_status_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_pass_brigade' + LibSuff8;

{
 * This function is used to register an input filter with the system. 
 * After this registration is performed, then a filter may be added 
 * into the filter chain by using ap_add_input_filter() and simply 
 * specifying the name.
 *
 * @param name The name to attach to the filter function
 * @param filter_func The filter function to name
 * @param filter_init The function to call before the filter handlers 
                      are invoked
 * @param ftype The type of filter function, either ::AP_FTYPE_CONTENT or
 *              ::AP_FTYPE_CONNECTION
 * @see add_input_filter()
 }
function ap_register_input_filter(const name: PAnsiChar;
 filter_func: ap_in_filter_func; filter_init: ap_init_filter_func;
 ftype: ap_filter_type): Pap_filter_rec_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_register_input_filter' + LibSuff16;

{
 * This function is used to register an output filter with the system. 
 * After this registration is performed, then a filter may be added 
 * into the filter chain by using ap_add_output_filter() and simply 
 * specifying the name.
 *
 * @param name The name to attach to the filter function
 * @param filter_func The filter function to name
 * @param filter_init The function to call before the filter handlers 
 *                    are invoked
 * @param ftype The type of filter function, either ::AP_FTYPE_CONTENT or
 *              ::AP_FTYPE_CONNECTION
 * @see ap_add_output_filter()
 }
function ap_register_output_filter(const name: PAnsiChar;
 filter_func: ap_out_filter_func; filter_init: ap_init_filter_func;
 ftype: ap_filter_type): Pap_filter_rec_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_register_output_filter' + LibSuff16;

{
 * Adds a named filter into the filter chain on the specified request record.
 * The filter will be installed with the specified context pointer.
 *
 * Filters added in this way will always be placed at the end of the filters
 * that have the same type (thus, the filters have the same order as the
 * calls to ap_add_filter). If the current filter chain contains filters
 * from another request, then this filter will be added before those other
 * filters.
 * 
 * To re-iterate that last comment.  This function is building a FIFO
 * list of filters.  Take note of that when adding your filter to the chain.
 *
 * @param name The name of the filter to add
 * @param ctx Context data to provide to the filter
 * @param r The request to add this filter for (or NULL if it isn't associated with a request)
 * @param c The connection to add the fillter for
 }
function ap_add_input_filter(const name: PAnsiChar; ctx: Pointer;
 r: Prequest_rec; c: Pconn_rec): Pap_filter_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_add_input_filter' + LibSuff16;

{
 * Variant of ap_add_input_filter() that accepts a registered filter handle
 * (as returned by ap_register_input_filter()) rather than a filter name
 *
 * @param f The filter handle to add
 * @param ctx Context data to provide to the filter
 * @param r The request to add this filter for (or NULL if it isn't associated with a request)
 * @param c The connection to add the fillter for
 }
function ap_add_input_filter_handle(f: Pap_filter_t;
 ctx: Pointer; r: Prequest_rec; c: Pconn_rec): Pap_filter_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_add_input_filter_handle' + LibSuff16;

{
 * Returns the filter handle for use with ap_add_input_filter_handle.
 *
 * @param name The filter name to look up
 }
function ap_get_input_filter_handle(const name: PAnsiChar): Pap_filter_rec_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_get_input_filter_handle' + LibSuff4;

{
 * Add a filter to the current request.  Filters are added in a FIFO manner.
 * The first filter added will be the first filter called.
 * @param name The name of the filter to add
 * @param ctx Context data to set in the filter
 * @param r The request to add this filter for (or NULL if it isn't associated with a request)
 * @param c The connection to add this filter for
 }
function ap_add_output_filter(const name: PAnsiChar; ctx: Pointer;
 r: Prequest_rec; c: Pconn_rec): Pap_filter_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_add_output_filter' + LibSuff16;

{
 * Variant of ap_add_output_filter() that accepts a registered filter handle
 * (as returned by ap_register_output_filter()) rather than a filter name
 *
 * @param f The filter handle to add
 * @param r The request to add this filter for (or NULL if it isn't associated with a request)
 * @param c The connection to add the fillter for
 }
function ap_add_output_filter_handle(f: Pap_filter_rec_t;
 ctx: Pointer; r: Prequest_rec; c: Pconn_rec): Pap_filter_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_add_output_filter_handle' + LibSuff16;

{
 * Returns the filter handle for use with ap_add_output_filter_handle.
 *
 * @param name The filter name to look up
 }
function ap_get_output_filter_handle(const name: PAnsiChar): Pap_filter_rec_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_get_output_filter_handle' + LibSuff4;

{
 * Remove an input filter from either the request or connection stack
 * it is associated with.
 * @param f The filter to remove
 }
procedure ap_remove_input_filter(f: Pap_filter_t);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_remove_input_filter' + LibSuff4;

{
 * Remove an output filter from either the request or connection stack
 * it is associated with.
 * @param f The filter to remove
 }
procedure ap_remove_output_filter(f: Pap_filter_t);
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_remove_output_filter' + LibSuff4;

{ The next two filters are for abstraction purposes only.  They could be
 * done away with, but that would require that we break modules if we ever
 * want to change our filter registration method.  The basic idea, is that
 * all filters have a place to store data, the ctx pointer.  These functions
 * fill out that pointer with a bucket brigade, and retrieve that data on
 * the next call.  The nice thing about these functions, is that they
 * automatically concatenate the bucket brigades together for you.  This means
 * that if you have already stored a brigade in the filters ctx pointer, then
 * when you add more it will be tacked onto the end of that brigade.  When
 * you retrieve data, if you pass in a bucket brigade to the get function,
 * it will append the current brigade onto the one that you are retrieving.
 }

{
 * prepare a bucket brigade to be setaside.  If a different brigade was 
 * set-aside earlier, then the two brigades are concatenated together.
 * @param f The current filter
 * @param save_to The brigade that was previously set-aside.  Regardless, the
 *             new bucket brigade is returned in this location.
 * @param b The bucket brigade to save aside.  This brigade is always empty
 *          on return
 * @param p Ensure that all data in the brigade lives as long as this pool
 }
function ap_save_brigade(f: Pap_filter_t;
 save_to, b: PPapr_bucket_brigade; p: Papr_pool_t): apr_status_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_save_brigade' + LibSuff16;

{
 * Flush function for apr_brigade_* calls.  This calls ap_pass_brigade
 * to flush the brigade if the brigade buffer overflows.
 * @param bb The brigade to flush
 * @param ctx The filter to pass the brigade to
 * @note this function has nothing to do with FLUSH buckets. It is simply
 * a way to flush content out of a brigade and down a filter stack.
 }
{AP_DECLARE_NONSTD(apr_status_t) ap_filter_flush(apr_bucket_brigade *bb,
                                                void *ctx);}

{
 * Flush the current brigade down the filter stack.
 * @param f The current filter
 * @param bb The brigade to flush
 }
function ap_fflush(f: Pap_filter_t; bb: Papr_bucket_brigade): apr_status_t;
 {$IFDEF WINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
 external LibHTTPD name LibNamePrefix + 'ap_fflush' + LibSuff8;

{
 * Write a buffer for the current filter, buffering if possible.
 * @param f the filter doing the writing
 * @param bb The brigade to buffer into
 * @param data The data to write
 * @param nbyte The number of bytes in the data
 }
{#define ap_fwrite(f, bb, data, nbyte) \
        apr_brigade_write(bb, ap_filter_flush, f, data, nbyte)}

{
 * Write a buffer for the current filter, buffering if possible.
 * @param f the filter doing the writing
 * @param bb The brigade to buffer into
 * @param str The string to write
 }
{#define ap_fputs(f, bb, str) \
        apr_brigade_puts(bb, ap_filter_flush, f, str)}

{
 * Write a character for the current filter, buffering if possible.
 * @param f the filter doing the writing
 * @param bb The brigade to buffer into
 * @param c The character to write
 }
{#define ap_fputc(f, bb, c) \
        apr_brigade_putc(bb, ap_filter_flush, f, c)}

{
 * Write an unspecified number of strings to the current filter
 * @param f the filter doing the writing
 * @param bb The brigade to buffer into
 * @param ... The strings to write
 }
function ap_fputstrs(f: Pap_filter_t; bb: Papr_bucket_brigade;
 others: array of const): apr_status_t;
 cdecl; external LibHTTPD name 'ap_fputstrs';

{
 * Output data to the filter in printf format
 * @param f the filter doing the writing
 * @param bb The brigade to buffer into
 * @param fmt The format string
 * @param ... The argumets to use to fill out the format string
 }
function ap_fprintf(f: Pap_filter_t; bb: Papr_bucket_brigade;
 const fmt: PAnsiChar; others: array of const): apr_status_t;
 cdecl; external LibHTTPD name 'ap_fputstrs';

{        __attribute__((format(printf,3,4)));}

