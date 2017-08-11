function [res] = DoBackwardPass(net, res, params)

cudnn = {'NoCuDNN'};
opts.backPropDepth = length(net.layers)+1;


doder = true;
if(doder)
    n=length(res)-1;
    for i=n:-1:max(1,n-opts.backPropDepth+1)
        l=net.layers{i};
        res(i).backwardTime=tic;
        
        switch l.type

          case 'conv'
            [res(i).dzdx, dzdw{1}, dzdw{2}] = ...
              vl_nnconv(res(i).x, l.weights{1}, l.weights{2}, res(i+1).dzdx, ...
              'pad', l.pad, ...
              'stride', l.stride, ...
              l.opts{:}, ...
              cudnn{:}) ;

          case 'convt'
            [res(i).dzdx, dzdw{1}, dzdw{2}] = ...
              vl_nnconvt(res(i).x, l.weights{1}, l.weights{2}, res(i+1).dzdx, ...
              'crop', l.crop, ...
              'upsample', l.upsample, ...
              'numGroups', l.numGroups, ...
              l.opts{:}, ...
              cudnn{:}) ;

          case 'pool'
            res(i).dzdx = vl_nnpool(res(i).x, l.pool, res(i+1).dzdx, ...
                                    'pad', l.pad, 'stride', l.stride, ...
                                    'method', l.method, ...
                                    l.opts{:}, ...
                                    cudnn{:}) ;

          case {'normalize', 'lrn'}
            res(i).dzdx = vl_nnnormalize(res(i).x, l.param, res(i+1).dzdx) ;

          case 'softmax'
            res(i).dzdx = vl_nnsoftmax(res(i).x, res(i+1).dzdx) ;

          case 'loss'
            res(i).dzdx = vl_nnloss(res(i).x, l.class, res(i+1).dzdx) ;

          case 'softmaxloss'
            res(i).dzdx = vl_nnsoftmaxloss(res(i).x, l.class, res(i+1).dzdx) ;

          case 'relu'
            if l.leak > 0, leak = {'leak', l.leak} ; else leak = {} ; end
            if ~isempty(res(i).x)
              res(i).dzdx = vl_nnrelu(res(i).x, res(i+1).dzdx, leak{:}) ;
            else
              % if res(i).x is empty, it has been optimized away, so we use this
              % hack (which works only for ReLU):
              res(i).dzdx = vl_nnrelu(res(i+1).x, res(i+1).dzdx, leak{:}) ;
            end

          case 'sigmoid'
            res(i).dzdx = vl_nnsigmoid(res(i).x, res(i+1).dzdx) ;

          case 'noffset'
            res(i).dzdx = vl_nnnoffset(res(i).x, l.param, res(i+1).dzdx) ;

          case 'spnorm'
            res(i).dzdx = vl_nnspnorm(res(i).x, l.param, res(i+1).dzdx) ;

          case 'dropout'
            if testMode
              res(i).dzdx = res(i+1).dzdx ;
            else
              res(i).dzdx = vl_nndropout(res(i).x, res(i+1).dzdx, ...
                                         'mask', res(i+1).aux) ;
            end

          case 'bnorm'
            [res(i).dzdx, dzdw{1}, dzdw{2}, dzdw{3}] = ...
              vl_nnbnorm(res(i).x, l.weights{1}, l.weights{2}, res(i+1).dzdx) ;
            % multiply the moments update by the number of images in the batch
            % this is required to make the update additive for subbatches
            % and will eventually be normalized away
            dzdw{3} = dzdw{3} * size(res(i).x,4) ;

          case 'pdist'
            res(i).dzdx = vl_nnpdist(res(i).x, l.class, ...
              l.p, res(i+1).dzdx, ...
              'noRoot', l.noRoot, ...
              'epsilon', l.epsilon, ...
              'aggregate', l.aggregate, ...
              'instanceWeights', l.instanceWeights) ;

          case 'custom'
            res(i) = l.backward(l, res(i), res(i+1)) ;

        end % layers

        switch l.type
          case {'conv', 'convt', 'bnorm'}
%             if ~opts.accumulate
%               res(i).dzdw = dzdw ;
%               for DummyInd = 1:numel(dzdw)
%                 res(i).dzdw{DummyInd} = zeros(size(dzdw{DummyInd}));
%               end
%             else
%               for j=1:numel(dzdw)
%                 res(i).dzdw{j} = res(i).dzdw{j} + dzdw{j} ;
%               end
%             end
            dzdw = [] ;
        end
        
        res(i).backwardTime = toc(res(i).backwardTime) ;
    end
end

end