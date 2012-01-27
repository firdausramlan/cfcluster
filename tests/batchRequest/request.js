Request = (function(){

    var prefixUrl = '../../cf/serviceBus/',
        testUrl = prefixUrl + 'Test.cfc',
        transactionUrl = prefixUrl + 'Transaction.cfc';
    
    return {
    
        init: function(){
            
            console.info('Begin testing');

        },
        
        request: function(concurrency){
        
            for(var i = 1; i <= concurrency; i++){
                params = {
                    request: 'ConcurrentLock ' + i ,
                    method: 'request'
                }
                this.doRequest(testUrl, params);
            }
            
        },
        
        writeRead: function(){
        
            this.doRequest(testUrl, {
                method: 'setRequest',
                request: 'SetRequest'
            });

            this.doRequest.defer(10, this, [testUrl, {
                method: 'getRequest',
                request: 'GetRequest'
            }]);
               
            
        }, 
        
        readWrite: function(){
        
            this.doRequest(testUrl, {
                method: 'getRequest',
                request: 'GetRequest'
            });
            
            this.doRequest.defer(10, this, [testUrl, {
                method: 'setRequest',
                request: 'SetRequest'
            }]);
            
        }, 
        
        readOnly: function(concurrency){
        
            for(var i = 1; i <= concurrency; i++){
                params = {
                    request: 'ReadOnly ' + i ,
                    method: 'getRequest'
                }
                this.doRequest.defer(10, this, [testUrl, params]);
            }
            
        }, 
        
        dbRead: function(concurrency){
        
            for(var i = 1; i <= concurrency; i++){
                params = {
                    request: 'DBRead ' + i ,
                    method: 'read'
                }
                this.doRequest(transactionUrl, params);
            }
            
        },
        
        doRequest: function(url, params){
        
            console.log(params.request, url, params);
            console.time(params.request);            
            
            Ext.Ajax.request({
                url: url,
                method: 'post',
                params: params,
                success: function(r, o){
                    var data = Ext.decode(r.responseText);
                    console.timeEnd(params.request);
                    console.info(params.request,' Complete', data);
                },
                
                failure: function(){
                    console.timeEnd(params.request);
                    console.warn(params.request, ' Failed.', arguments);
                }
            })
            
        }
        
    }
    
})();


Ext.onReady(Request.init, Request);