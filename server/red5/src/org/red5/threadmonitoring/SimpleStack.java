/*
 * Created on 5/9/2003
 */
package org.red5.threadmonitoring;

import java.util.EmptyStackException;

/**
 * Class represents stack of <code>long</code> -type elements. <br>
 * Besides common stack operations like <b>pop </b>, <b>push </b> it is easy to
 * retrieve each element of the stack. <br>
 * Storage of the stack is simple array of longs.
 */
public class SimpleStack {

  private static final int INITIAL_CAPACITY = 10;

  private long[] data;

  private int size = 0;

  /**
   * Creates instance of SimpleStack with initial capasity of 10.
   */
  public SimpleStack() {
    this(INITIAL_CAPACITY);
  }

  /**
   * Creates instance of SimpleStack using given initial size. <br>
   * If negative size is passed, stack is initialized with default initial
   * capasity, equals 10.
   * 
   * @param size
   *          initial capasity of the stack being created.
   */
  public SimpleStack(int size) {
    data = (size > 0) ? new long[size] : new long[INITIAL_CAPACITY];
  }

  /**
   * Pushes element to the stack. <br>
   * Before storing element in the stack, method
   * {@link #ensureCapacity(int) ensureCapacity}is called to ensure that there
   * is enough space to store new element.
   * 
   * @param element
   *          new element is being pushed to the stack.
   */
  public void push(long element) {
    ensureCapacity(size + 1);
    data[size++] = element;
  }

  /**
   * Pops and returns element from the stack. <br>
   * If stack is empty
   * {@link ArrayIndexOutOfBoundsException ArrayIndexOfBoundException}is
   * thrown. <br>
   * Method does not affect the array, it just decrement stack size value.
   * 
   * @return element on the top of stack.
   * 
   * @throws EmptyStackException
   *           if operation is proceed on empty stack.
   */
  public long pop() {
    if (size == 0) {
      throw new EmptyStackException();
    }
    return data[--size];
  }

  /**
   * Retrieves element of the stack by specified position. <br>
   * The top element of stack has the biggest position equal to
   * {@link #size() size()}- 1.<br>
   * If position < 0 || position >= SimpleStack#size(),
   * IndexOutOfBoundsException is thrown.
   * 
   * @param pos
   *          position of the element to retrieve.
   * 
   * @return element of the stack at position <code>pos</code>
   * 
   * @throws IndexOutOfBoundsException
   *           if operation is executed on an empty stack.
   */
  public long elementAt(int pos) {
    if (pos < 0 || pos >= size) {
      throw new IndexOutOfBoundsException("Invalid index: " + pos + " (size: " + size + ")");
    }
    return this.data[pos];
  }

  /**
   * Retrieves current size of the stack.
   * 
   * @return number of elements, being pushed but not yet poped.
   */
  public int size() {
    return size;
  }

  /**
   * Checks whether stack is empty.
   * 
   * @return <code>true</code> stack size is zero; otherwise returns
   *         <code>false<code>.
   */
  public boolean isEmpty() {
    return size == 0;
  }

  /**
   * Ensures that the stack array capacity will be greater or equal than
   * <code>newSize</code>.<br>
   * New capacity is calculated as: <br>
   * <code>newCapasity = (oldCapasity * 3) / 2 + 1<code><br>  
   * Then if new capacity is still less than requested one,
   * it is set with the requested value of <code>newSize<code>.  
   * After that new array with new capasity is created and values  
   * of old one are copied to the new array using
   * {@link System#arraycopy(java.lang.Object, int, java.lang.Object, int, int) arraycopy} method with number of elements,  
   * being pushed but not yet poped, passed to it.
   * If <code>newSize</code> is less or equal than oldCapasity, method does nothing.   
   *  
   * @param newSize                           new capasity of storage array.
   */
  public void ensureCapacity(int newSize) {
    int oldCapacity = data.length;
    if (newSize > oldCapacity) {
      int newCapacity = (oldCapacity * 3) / 2 + 1;
      if (newCapacity < newSize) {
        newCapacity = newSize;
      }
      long[] newData = new long[newCapacity];
      System.arraycopy(data, 0, newData, 0, oldCapacity);
      data = newData;
    }
  }

}