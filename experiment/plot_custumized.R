# customized plot to GA results

plot_customized <- 
  function(x,
           y,
           ylim,
           ylab_kpi,
           cex.points = 0.7,
           col = c("green3",
                   "dodgerblue3",
                   adjustcolor("green3", alpha.f = 0.1)), 
           pch = c(16, 1),
           lty = c(1, 2),
           legend = TRUE,
           grid = graphics:::grid, ...) {
    
    object <- x
    is.final <- !(any(is.na(object@summary[, 1])))
    iters <- if (is.final) {1:object@iter} else {1:object@maxiter}
    summary <- object@summary
    
    if (missing(ylim)) {
      
      ylim <- c(max(apply(summary[, c(2, 4)], 2,
                          function(x) min(range(x,
                                                na.rm = TRUE,
                                                finite = TRUE)))),
                max(range(summary[, 1],
                          na.rm = TRUE,
                          finite = TRUE)))
      
    }
    
    plot(iters,
         summary[, 1],
         type = "n",
         ylim = ylim,
         xlab = "Generation", 
         ylab = ylab_kpi, ...)
    
    if (is.final & is.function(grid)) {grid(equilogs = FALSE)}
    
    points(iters,
           summary[, 1],
           type = ifelse(is.final, "o", "p"),
           pch = pch[1],
           lty = lty[1],
           col = col[1],
           cex = cex.points)
    
    points(iters,
           summary[, 2],
           type = ifelse(is.final, "o", "p"),
           pch = pch[2],
           lty = lty[2],
           col = col[2],
           cex = cex.points)
    
    if (is.final) {
      
      polygon(c(iters, rev(iters)),
              c(summary[, 4], rev(summary[, 1])),
              border = FALSE,
              col = col[3])
      
    } else {
      
      title(paste("Iteration", object@iter),
            font.main = 1)
      
    }
    if (is.final & legend) {
      inc <- !is.na(col)
      
      legend("topright", 
             legend = c("Best", "Mean", "Median"), 
             col = c("green3",
                     "dodgerblue3",
                     adjustcolor("green3", alpha.f = 0.1)), 
             pch = c(16, 1), 
             lty = c(1, 2), 
             lwd = c(1, 1, 10), 
             inset = 0.02)
    }
    
    out <- data.frame(iter = iters, summary)
    invisible(out)
    
  }
